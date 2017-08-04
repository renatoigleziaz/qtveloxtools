import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.0
import "../q-js/ui.js" as UI

Calendar {
    id: calendar
    frameVisible: false
    weekNumbersVisible: false

    Component.onCompleted: {

        UI.context()
    }

    selectedDate: new Date()
    focus: true
    style: CalendarStyle {
        gridVisible: false
        dayDelegate: Rectangle {
            readonly property color sameMonthDateTextColor: Material.foreground
            readonly property color selectedDateColor: Material.accent
            readonly property color selectedDateTextColor: styleData.selected
                                                           ? "#373737"
                                                           : Material.accent
            readonly property color differentMonthDateTextColor: "#444"
            readonly property color invalidDatecolor: "#dddddd"
            border.color: "transparent"
            Rectangle {
                anchors.fill: parent
                border.color: "transparent"
                color: styleData.selected ? Material.accent : Material.background
                anchors.margins: styleData.selected ? -1 : 0
            }
            Label {
                id: dayDelegateText
                text: styleData.date.getDate()
                anchors.centerIn: parent
                color: {
                    var color = invalidDatecolor;
                    if (styleData.valid) {
                        color = styleData.visibleMonth
                                ? sameMonthDateTextColor
                                : differentMonthDateTextColor;
                        if (styleData.selected) {
                            color = selectedDateTextColor;
                        }
                    }
                    color;
                }
            }
        }
        navigationBar: Rectangle {
            color: Material.accent
            height: 48

            Rectangle {
                color: Material.accent
                height: 1
                width: parent.width
                anchors.bottom: parent.bottom
            }

            Q_ToolButton {
                id: btnPrev
                text: "<"
                Material.foreground: "#373737"
                font.pixelSize: UI.tscale(22)
                width: parent.height - 8
                height: width
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 2
                onClicked: calendar.showPreviousMonth()
            }

            Q_Label {
                text: styleData.title
                elide: Text.ElideRight
                color: "#373737"
                anchors.left: btnPrev.right
                anchors.leftMargin: 2
                anchors.right: btnNext.left
                anchors.rightMargin: 2
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Q_ToolButton {
                id: btnNext
                text: ">"
                font.pixelSize: UI.tscale(22)
                Material.foreground: "#373737"
                width: parent.height - 8
                height: width
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 2
                onClicked: calendar.showNextMonth()
            }
        }
        dayOfWeekDelegate: Rectangle {
            color: Material.background
            height: 48
            Label {
                text: calendar.__locale.dayName(styleData.dayOfWeek, control.dayOfWeekFormat)
                anchors.centerIn: parent
                color: Material.accent
            }
        }
    }

    SystemPalette {
        id: systemPalette
    }
}
