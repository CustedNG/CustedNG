//
//  Schedule.swift
//  CustedHomeWidgetExtension
//
//  Created by LollipopKit on 2021/4/15.
//

import WidgetKit
import SwiftUI
import Intents


func date2String(_ date:Date, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale.init(identifier: "zh_CN")
    formatter.dateFormat = dateFormat
    let date = formatter.string(from: date)
    return date
}

struct ScheduleProvider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (ScheduleEntry) -> Void) {
        let entry = ScheduleEntry(date: Date(), data: Schedule(teacher: "张三", position: "西区主教501", course: "概率论", time: "14:00", updateTime: "13:00"))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ScheduleEntry>) -> Void) {
        typealias Entry = ScheduleEntry
        
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 6, to: currentDate)!
        ScheduleLoader.fetch { result in
            let oneWord: Schedule
            if case .success(let fetchedData) = result {
                oneWord = fetchedData
            } else {
                oneWord = Schedule(teacher: "建议稍后再试", position: "刷新失败", course: "抱歉", time: "", updateTime: date2String(currentDate, dateFormat: "HH:mm"))
            }
            let entry = ScheduleEntry(date: currentDate, data: oneWord)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }

    func placeholder(in context: Context) -> ScheduleEntry {
        return ScheduleEntry(date: Date(), data: Schedule(teacher: "张三", position: "西区主教501", course: "概率论", time: "13:00", updateTime: "13:00"))
    }
}

struct ScheduleEntry: TimelineEntry {
    public let date: Date
    public let data: Schedule
}

struct SchedulePlaceholderView : View {
    //这里是PlaceholderView - 提醒用户选择部件功能
    var body: some View {
        Text("人类的悲欢并不相通，我只觉得他们吵闹。")
    }
}

struct ScheduleEntryView : View {
    //这里是Widget的类型判断
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: ScheduleProvider.Entry
    
    @ViewBuilder
    var body: some View {
        ScheduleView(entry: entry)
    }
}

struct ScheduleWidget: Widget {
    private let kind: String = "ScheduleWidget"
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ScheduleProvider()) { entry in
            ScheduleEntryView(entry: entry)
        }
        .configurationDisplayName("课表")
        .description("便捷查看下节课")
        .supportedFamilies([.systemSmall])
    }
}

struct Schedule {
    let teacher: String
    let position: String
    let course: String
    let time: String
    let updateTime: String
}

struct ScheduleLoader {
    static func fetch(completion: @escaping (Result<Schedule, Error>) -> Void) {
        let oneWordURL = URL(string: "https://push.lolli.tech/")!
        let task = URLSession.shared.dataTask(with: oneWordURL) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            let oneWord = getScheduleInfo(fromData: data!)
            completion(.success(oneWord))
        }
        task.resume()
    }

    static func getScheduleInfo(fromData data: Foundation.Data) -> Schedule {
        return Schedule(teacher: "还在开发中", position: "此功能", course: "抱歉", time: "敬请期待", updateTime: date2String(Date(), dateFormat: "HH:mm"))
    }
}

struct ScheduleView: View {
    let entry: ScheduleEntry
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(entry.data.course)
                .font(.system(.title2))
                .foregroundColor(.white)
                .frame(width: .none, height: .none, alignment: .topLeading)
            Spacer()
            Text(entry.data.position)
                .font(.system(.caption))
                .foregroundColor(.white)
            Text(entry.data.teacher)
                .font(.system(.caption))
                .foregroundColor(.white)
            Text(entry.data.time)
                .font(.system(.caption))
                .foregroundColor(.white)
            Spacer()
            Text("更新于\(entry.data.updateTime)")
                .font(.system(.caption2))
                .foregroundColor(.white)
                .frame(width: .none, height: .none, alignment: .bottom)
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.pink, .purple, .pink]), startPoint: .topLeading, endPoint: .bottom))
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(entry: ScheduleEntry(date: Date(), data: Schedule(teacher: "张三", position: "西区主教501", course: "概率论", time: "13:00", updateTime: date2String(Date(), dateFormat: "HH:mm"))))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

