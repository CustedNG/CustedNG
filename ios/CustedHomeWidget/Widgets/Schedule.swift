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

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
}

extension Color {
    init(uiColor: UIColor) {
        self.init(red: Double(uiColor.rgba.red),
                  green: Double(uiColor.rgba.green),
                  blue: Double(uiColor.rgba.blue),
                  opacity: Double(uiColor.rgba.alpha))
    }
}

func date2String(_ date:Date, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale.init(identifier: "zh_CN")
    formatter.dateFormat = dateFormat
    let date = formatter.string(from: date)
    return date
}

struct ScheduleProvider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (ScheduleEntry) -> Void) {
        let entry = ScheduleEntry(
            date: Date(),
            data: Schedule(teacher: "张三", position: "西区主教501", course: "概率论", time: "14:00", updateTime: "13:00")
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
            data: Schedule(teacher: "张三", position: "西区主教501", course: "概率论", time: "13:00", updateTime: "13:00")
        )
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
        let ecardId = widgetData?.string(forKey: "ecardId")
        guard ecardId != nil else {
            completion(.success(Schedule(teacher: "成功登录、刷新课表", position: "请打开App", course: "无数据", time: "并等待下一次刷新", updateTime: date2String(Date(), dateFormat: "HH:mm"))))
            return
        }
        let scheduleURL = URL(string: "https://v3.custed.lolli.tech/schedule/next/" + ecardId!)!
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
        if (str == "today have no more lesson") {
            return Schedule(teacher: "去放松一下吧", position: "没有课啦", course: "今天", time: "(｡ì _ í｡)", updateTime: date2String(Date(), dateFormat: "HH:mm"))
        }
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let name = json["Name"] as! String
        let teacher = json["Teacher"] as! String
        let time = json["StartTime"] as! String
        let position = json["Position"] as! String
        return Schedule(teacher: teacher, position: position, course: name, time: time, updateTime: date2String(Date(), dateFormat: "HH:mm"))
    }
}

struct ScheduleView: View {
    let entry: ScheduleEntry
    
    let bgColor = DynamicColor(dark: UIColor(.black), light: UIColor(.white))
    let textColor = DynamicColor(dark: UIColor(.white), light: UIColor(.black))
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.7) {
            Text(entry.data.course)
                .font(.system(.title3))
                .foregroundColor(.blue)
                .frame(width: .none, height: .none, alignment: .topLeading)
            Spacer()
            DetailItem(icon: "location", text: entry.data.position, color: dynamicColor(color: textColor).opacity(0.7))
            DetailItem(icon: "person", text: entry.data.teacher, color: dynamicColor(color: textColor).opacity(0.7))
            DetailItem(icon: "clock", text: entry.data.time, color: dynamicColor(color: textColor).opacity(0.7))
            Spacer()
            Text("更新于\(entry.data.updateTime)")
                .font(.system(.caption2))
                .foregroundColor(dynamicColor(color: textColor).opacity(0.6))
                .frame(width: .none, height: .none, alignment: .bottom)
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        .background(dynamicColor(color: bgColor))
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(
            entry: ScheduleEntry(
                date: Date(),
                data: Schedule(teacher: "张三", position: "西区主教501", course: "概率论", time: "13:00", updateTime: date2String(Date(), dateFormat: "HH:mm")
                )
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
        HStack() {
            Image(systemName: icon).resizable().foregroundColor(color).frame(width: 12, height: 12, alignment: .center)
            Text(text)
                .font(.system(.caption2))
                .foregroundColor(color)
        }
    }
}
