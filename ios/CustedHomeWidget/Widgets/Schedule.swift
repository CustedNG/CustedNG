//
//  Schedule.swift
//  CustedHomeWidgetExtension
//
//  Created by LollipopKit on 2021/4/15.
//

import WidgetKit
import SwiftUI
import Intents

private let widgetGroupId = "group.com.tusi.app"
private let widgetData = UserDefaults.init(suiteName: widgetGroupId)

func date2String(_ date:Date, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale.init(identifier: "zh_CN")
    formatter.dateFormat = dateFormat
    let date = formatter.string(from: date)
    return date
}

let demoSchedule = Schedule(teacher: "张三", position: "西区主教501", course: "概率论", time: "14:00", updateTime: "13:00")

struct ScheduleProvider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (ScheduleEntry) -> Void) {
        let entry = ScheduleEntry(
            date: Date(),
            data: demoSchedule
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ScheduleEntry>) -> Void) {
        typealias Entry = ScheduleEntry
        
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .second, value: 6, to: currentDate)!
        ScheduleLoader.fetch { result in
            let schedule: Schedule
            if case .success(let fetchedData) = result {
                schedule = fetchedData
            } else {
                schedule = Schedule(teacher: "无数据", position: "刷新失败", course: "抱歉", time: "请稍后再试", updateTime: date2String(currentDate, dateFormat: "HH:mm"))
            }
            
            let entry = ScheduleEntry(
                date: currentDate,
                data: schedule
            )
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }

    func placeholder(in context: Context) -> ScheduleEntry {
        return ScheduleEntry(
            date: Date(),
            data: demoSchedule
        )
    }
}

struct ScheduleEntry: TimelineEntry {
    public let date: Date
    public let data: Schedule
}

struct ScheduleEntryView : View {
    @Environment(\.widgetFamily)
    var family: WidgetFamily
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
        let ecardId = widgetData?.string(forKey: "ecardId")
        guard ecardId != nil else {
            completion(.success(Schedule(teacher: "成功登录、刷新课表", position: "请打开App", course: "无数据", time: "并等待下一次刷新", updateTime: date2String(Date(), dateFormat: "HH:mm"))))
            return
        }
        let scheduleURL = URL(string: "https://api.backend.cust.team/schedule/next/" + ecardId!)!
        let task = URLSession.shared.dataTask(with: scheduleURL) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            let schedule = getScheduleInfo(fromData: data!)
            completion(.success(schedule))
        }
        task.resume()
    }

    static func getScheduleInfo(fromData data: Foundation.Data) -> Schedule {
        let str = String(decoding: data, as: UTF8.self)
        if (str.contains("today have no more lesson")) {
            return Schedule(teacher: "去放松一下吧", position: "没有课啦", course: "今天", time: "(｡ì _ í｡)", updateTime: date2String(Date(), dateFormat: "HH:mm"))
        }
        
        let dateStr = date2String(Date(), dateFormat: "HH:mm")

        let jsonAll = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let code = jsonAll["code"] as! Int
        if (code != -1) {
            switch (code) {
            case 6:
                return Schedule(teacher: "成功刷新课表", position: "请在app", course: "失败", time: "再添加小部件", updateTime: dateStr)
            default:
                let msg = jsonAll["message"] as! String? ?? ""
                return Schedule(teacher: "错误码:\(code)", position: "刷新失败", course: "抱歉", time: msg, updateTime: dateStr)
            }
        }

        let json = jsonAll["data"] as! [String: Any]
        let name = json["Name"] as! String
        let teacher = json["Teacher"] as! String
        let time = json["StartTime"] as! String
        let position = json["Position"] as! String
        return Schedule(teacher: teacher, position: position, course: name, time: time, updateTime: date2String(Date(), dateFormat: "HH:mm"))
    }
}

let bgColor = DynamicColor(dark: UIColor(.black), light: UIColor(.white))
let textColor = DynamicColor(dark: UIColor(.white), light: UIColor(.black))

struct ScheduleView: View {
    let entry: ScheduleEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4.7) {
            Text(entry.data.course)
                .font(.system(.title3))
                .foregroundColor(.blue)
            Spacer()
            DetailItem(icon: "location", text: entry.data.position, color: dynamicColor(color: textColor).opacity(0.7))
            DetailItem(icon: "person", text: entry.data.teacher, color: dynamicColor(color: textColor).opacity(0.7))
            DetailItem(icon: "clock", text: entry.data.time, color: dynamicColor(color: textColor).opacity(0.7))
            Spacer()
            Text("更新于 \(entry.data.updateTime)")
                .font(.system(.caption2))
                .foregroundColor(dynamicColor(color: textColor).opacity(0.6))
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        .background(dynamicColor(color: bgColor))
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        let date = Date()
        ScheduleView(
            entry: ScheduleEntry(
                date: date,
                data: demoSchedule
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

private func dynamicUIColor(color: DynamicColor) -> UIColor {
    if #available(iOS 13, *) {  // 版本号大于等于13
  return UIColor { (traitCollection: UITraitCollection) -> UIColor in
    return traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark ?
      color.dark : color.light
  }
}
    return color.light
}

private func dynamicColor(color: DynamicColor) -> Color {
    return Color.init(dynamicUIColor(color: color))
}

struct DynamicColor {
    let dark: UIColor
    let light: UIColor
}

struct DetailItem: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 5.7) {
            Image(systemName: icon).resizable().foregroundColor(color).frame(width: 11, height: 11, alignment: .center)
            Text(text)
                .font(.system(.caption2))
                .foregroundColor(color)
        }
    }
}
