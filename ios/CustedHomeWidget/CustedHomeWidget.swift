//
//  CustedHomeWidget.swift
//  CustedHomeWidget
//
//  Created by LollipopKit on 2021/4/14.
//

import WidgetKit
import SwiftUI
import Intents

@main
struct Widgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        ScheduleWidget()
    }
}
