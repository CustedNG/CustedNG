//
//  OneWord.swift
//  CustedHomeWidgetExtension
//
//  Created by LollipopKit on 2021/4/15.
//

import WidgetKit
import SwiftUI
import Intents

struct OneWordProvider: TimelineProvider {
    func placeholder(in context: Context) -> OneWordEntry {
        return  OneWordEntry(date: Date(),data: OneWord(content: "人类的悲欢并不相通，我只觉得他们吵闹", length: 18))
    }
    func getSnapshot(in context: Context, completion: @escaping (OneWordEntry) -> Void) {
        let entry = OneWordEntry(date: Date(),data: OneWord(content: "人类的悲欢并不相通，我只觉得他们吵闹", length: 18))
        completion(entry)
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 60, to: currentDate)!
        OneWordLoader.fetch { result in
            let oneWord: OneWord
            if case .success(let fetchedData) = result {
                oneWord = fetchedData
            } else {
                oneWord = OneWord(content: "很遗憾本次更新失败,等待下一次更新.", length: 18)
            }
            let entry = OneWordEntry(date: currentDate,data: oneWord)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
}

struct OneWordEntry: TimelineEntry {
    public let date: Date
    public let data: OneWord
}

struct OneWordPlaceholderView : View {
    //这里是PlaceholderView - 提醒用户选择部件功能
    var body: some View {
        Text("人类的悲欢并不相通，我只觉得他们吵闹。")
    }
}

struct OneWordEntryView : View {
    //这里是Widget的类型判断
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: OneWordProvider.Entry
    
    @ViewBuilder
    var body: some View {
        OneWordView(content: entry.data.content)
    }
}

struct OneWordWidget: Widget {
    private let kind: String = "OneWordWidget"
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: OneWordProvider()) { entry in
            OneWordEntryView(entry: entry)
        }
        .configurationDisplayName("一言")
        .description("每小时刷新一言")
        .supportedFamilies([.systemSmall, .systemMedium])
        
    }
}

struct OneWord {
    let content: String
    let length: Int
}
struct OneWordLoader {
    static func fetch(completion: @escaping (Result<OneWord, Error>) -> Void) {
        let oneWordURL = URL(string: "https://v1.hitokoto.cn/")!
        let task = URLSession.shared.dataTask(with: oneWordURL) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            let oneWord = getOneWordInfo(fromData: data!)
            completion(.success(oneWord))
        }
        task.resume()
    }

    static func getOneWordInfo(fromData data: Foundation.Data) -> OneWord {
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let content = json["hitokoto"] as! String
        let length = json["length"] as! Int
        return OneWord(content: content, length: length)
    }
}

struct OneWordView: View {
    var content:String = "每日一言"
    var body: some View {
        Text(content)
            .multilineTextAlignment(.center)
            .padding()
    }
}

struct OneWordView_Previews: PreviewProvider {
    static var previews: some View {
        OneWordView(content: "PlaceHolder")
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

