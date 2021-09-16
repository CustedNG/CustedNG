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
     
    // Hex String -> UIColor
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
         
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
         
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
         
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
         
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
         
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
     
    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
         
        let multiplier = CGFloat(255.999999)
         
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
         
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}

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
            data: Schedule(teacher: "张三", position: "西区主教501", course: "概率论", time: "14:00", updateTime: "13:00"),
            color1: Color.pink,
            color2: Color.purple
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ScheduleEntry>) -> Void) {
        typealias Entry = ScheduleEntry
        
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .second, value: 6, to: currentDate)!
        ScheduleLoader.fetch { result in
            let oneWord: Schedule
            if case .success(let fetchedData) = result {
                oneWord = fetchedData
            } else {
                oneWord = Schedule(teacher: "建议稍后再试", position: "刷新失败", course: "抱歉", time: "", updateTime: date2String(currentDate, dateFormat: "HH:mm"))
            }
            
            let color1Str = widgetData?.string(forKey: "color1")
            let color2Str = widgetData?.string(forKey: "color2")
            let color1: Color = color1Str != nil ? Color(uiColor: UIColor(hexString: color1Str!)) : Color.pink
            let color2: Color = color2Str != nil ? Color(uiColor: UIColor(hexString: color2Str!)) : Color.purple
            let entry = ScheduleEntry(
                date: currentDate,
                data: oneWord,
                color1: color1,
                color2: color2
            )
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }

    func placeholder(in context: Context) -> ScheduleEntry {
        return ScheduleEntry(
            date: Date(),
            data: Schedule(teacher: "张三", position: "西区主教501", course: "概率论", time: "13:00", updateTime: "13:00"),
            color1: Color.pink,
            color2: Color.purple
        )
    }
}

struct ScheduleEntry: TimelineEntry {
    public let date: Date
    public let data: Schedule
    public let color1: Color
    public let color2: Color
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
        let scheduleURL = URL(string: "https://v2.custed.lolli.tech/schedule/next/" + ecardId!)!
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
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(entry.data.course)
                .font(.system(.title3))
                .foregroundColor(.white)
                .frame(width: .none, height: .none, alignment: .topLeading)
            Spacer()
            Text(entry.data.position)
                .font(.system(.caption2))
                .foregroundColor(.white)
            Text(entry.data.teacher)
                .font(.system(.caption2))
                .foregroundColor(.white)
            Text(entry.data.time)
                .font(.system(.caption2))
                .foregroundColor(.white)
            Spacer()
            Text("更新于\(entry.data.updateTime)")
                .font(.system(.caption2))
                .foregroundColor(.white)
                .frame(width: .none, height: .none, alignment: .bottom)
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        .background(LinearGradient(gradient: Gradient(colors: [entry.color1, entry.color2, entry.color1]), startPoint: .topLeading, endPoint: .bottom))
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(
            entry: ScheduleEntry(
                date: Date(),
                data: Schedule(teacher: "张三", position: "西区主教501", course: "概率论", time: "13:00", updateTime: date2String(Date(), dateFormat: "HH:mm")
                ),
                color1: Color.pink,
                color2: Color.purple
            )
        )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

