//
//  Schedule.swift
//  CustedHomeWidgetExtension
//
//  Created by LollipopKit on 2021/4/15.
//

import WidgetKit
import SwiftUI
import Intents

struct ScheduleProvider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (ScheduleEntry) -> Void) {
        let entry = ScheduleEntry(date: Date(),data: Schedule(teacher: "张三", position: "西区主教501", course: "概率论", time: "14:00")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ScheduleEntry>) -> Void) {
        typealias Entry = ScheduleEntry
        
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 6, to: currentDate)!
        //逃逸闭包传入匿名函数 当调用completion时调用该匿名函数刷新Widget
        ScheduleLoader.fetch { result in
            let oneWord: Schedule
            if case .success(let fetchedData) = result {
                oneWord = fetchedData
            } else {
                oneWord = Schedule(teacher: "抱歉", position: "刷新失败", course: "稍后再试", time: "")
            }
            let entry = ScheduleEntry(date: currentDate, data: oneWord)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }

    func placeholder(in context: Context) -> ScheduleEntry {
        return ScheduleEntry(date: Date(), data: Schedule(teacher: "张三", position: "西区主教501", course: "概率论"， time: ""))
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
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct Schedule {
    let teacher: String
    let position: String
    let course: String
    let time: String
}

struct ScheduleLoader {
    static func fetch(completion: @escaping (Result<Schedule, Error>) -> Void) {
        let oneWordURL = URL(string: "https://v1.hitokoto.cn/")!
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
        return Schedule(teacher: "张三", position: "西区主教501", course: "概率论", time: "")
    }
}

struct ScheduleView: View {
    let entry: ScheduleEntry
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.data.course)
                        .font(.system(.title3))
                        .foregroundColor(.black)
                        .frame(width: .none, height: .none, alignment: .topLeading)
                    Text(entry.data.teacher)
                        .font(.system(.caption2))
                        .foregroundColor(.black)
                    Text(entry.data.position)
                        .font(.system(.caption2))
                        .foregroundColor(.black)
                    Text(entry.data.time)
                        .font(.system(.caption2))
                        .foregroundColor(.black)
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .top, endPoint: .bottom))
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(entry: ScheduleEntry(date: Date(), data: Schedule(teacher: "1", position: "2", course: "3", time: "")))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

