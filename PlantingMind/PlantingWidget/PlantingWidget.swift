//
//  PlantingWidget.swift
//  PlantingWidget
//
//  Created by 최은주 on 3/19/24.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MoodRecordEntry {
        let moods = self.fetchMoods()
        let entry = MoodRecordEntry(date: Date(), moods: moods)
        return entry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MoodRecordEntry) -> ()) {
        let moods = self.fetchMoods()
        let entry = MoodRecordEntry(date: Date(), moods: moods)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [MoodRecordEntry] = []
        let currentDate = Date()
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let data = self.fetchMoods()
            entries = [MoodRecordEntry(date: entryDate, moods: data)]
        }
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
    
    func fetchMoods() -> [MoodInfo] {
        let context = CoreDataStack().persistentContainer.viewContext
        
        let value = -41 // 오늘로부터 41일전까지의 기분 기록을 가져와야 함.
        let endDate = Date()
        let startDate =  Calendar.current.date(byAdding: .day, value: value, to: endDate) ?? endDate
        
        let fetchRequest = NSFetchRequest<MoodRecord>(entityName: "MoodRecord")
        let predicate = NSPredicate(format: "%K >= %@ && %K <= %@", #keyPath(MoodRecord.timestamp), startDate as NSDate, #keyPath(MoodRecord.timestamp), endDate as NSDate)
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest).map {
                return MoodInfo(date: $0.timestamp, mood: Mood(rawValue: $0.mood))
            }
            
            return result
            
        } catch {
            fatalError("Failed to fetch the mood records: \(error.localizedDescription)")
        }
    }
}

struct MoodInfo {
    let date: Date
    let mood: Mood?
}

struct MoodRecordEntry: TimelineEntry {
    var date: Date
    let moods: [MoodInfo]
}

struct PlantingWidgetEntryView : View {
    var entry: Provider.Entry
    
    let brickCount = 49
    let weekday = 7
    
    var body: some View {
        let day = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
        let dayCount = Calendar.current.component(.weekday, from: Date())
        
        // 위젯에 기분이 표시되는 날은 오늘 날짜가 표시되는 칸까지
        let blockDisplayRange = brickCount - (weekday - dayCount)
        
        
        let gridItem = GridItem(.flexible(maximum: 15), spacing: 2)
        
        LazyHGrid(rows: Array(repeating: gridItem, count: 7), spacing: 3, content: {
            ForEach(1...brickCount, id: \.self) { count in
                if count <= weekday {
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundColor(Color.Custom.select)
                        .frame(width: 15)
                        .overlay {
                            Text(day[count - 1].localized)
                                .font(.custom("Pretendard-Black", size: 11))
                                .fontWeight(.heavy)
                                .foregroundStyle(count == 1 ? .red : Color.Custom.point)
                        }
                } else if blockDisplayRange >= count {
                    // (요일 표기를 위한 7칸) 다음부터 기분 블록 시작
                    let value = -(dayCount + 42 - count)
                    let blockDate = Calendar.current.date(byAdding: .day, value: value, to: Date()) ?? Date()
                    
                    let color = entry.moods.filter { moodInfo in
                        Calendar.current.isDate(moodInfo.date, equalTo: blockDate, toGranularity: Calendar.Component.day)
                    }.first?.mood?.color ?? Color.Custom.widgetBackground
                    
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundColor(color)
                        .frame(width: 15)
                } else {
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundStyle(.clear)
                        .frame(width: 15)
                }
            }
        })
    }
}

struct PlantingWidget: Widget {
    let kind: String = "com.eunjoo.planting-mind.PlantingWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PlantingWidgetEntryView(entry: entry)
                    .containerBackground(Color.Custom.background, for: .widget)
            } else {
                PlantingWidgetEntryView(entry: entry)
                    .background(Color.Custom.background)
            }
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("app_title".localized)
        .description("widget_desc".localized)
    }
}

@available(iOS 17.0, *)
#Preview(as: .systemSmall) {
    PlantingWidget()
} timeline: {
    MoodRecordEntry(date: Date(), moods: [MoodInfo(date: Date(), mood: .bad)])
}
