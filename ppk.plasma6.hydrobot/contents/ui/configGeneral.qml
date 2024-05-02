import QtQuick 2.0
import QtCore
import QtQuick.Controls 2.5
import QtQuick.Layouts
import QtQuick.Dialogs

import org.kde.kirigami 2.20 as Kirigami
//import org.kde.plasma.plasmoid 2.0
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
	id: configGeneral

	// selected icon: 1 2 or 0 for custom
	property int cfg_selIcon
	property alias cfg_customImage: imagePathTextField.text
	property int cfg_hydroTime
	// animation style 0 1 2
	property int cfg_selAnimStyle
	property alias cfg_selPulse: pulseGoku.checked
	property int minutesValue: cfg_hydroTime / (60*1000)

	Kirigami.FormLayout {
		ButtonGroup {
			id: iconRadioGroup
		}
		ButtonGroup {
			id: animRadioGroup
		}

		Item {
			Kirigami.FormData.label: i18n("Image")
			Kirigami.FormData.isSection: true
		}
		RadioButton {
			//id: dropRadio
			ButtonGroup.group: iconRadioGroup
			text: i18n("Water Drop")
			checked: cfg_selIcon === 1
			onToggled: if (checked) cfg_selIcon = 1;
		}
		RadioButton {
			//id: glassRadio
			ButtonGroup.group: iconRadioGroup
			text: i18n("Glass")
			checked: cfg_selIcon === 2
			onToggled: if (checked) cfg_selIcon = 2;
		}
		RadioButton {
			id: customRadio
			ButtonGroup.group: iconRadioGroup
			text: i18n("Custom Icon...")
			checked: cfg_selIcon === 0
			onToggled: if (checked) cfg_selIcon = 0;
		}
		RowLayout {
			Layout.fillWidth: true
			Kirigami.ActionTextField {
				id: imagePathTextField
				enabled: customRadio.checked
				Layout.fillWidth: true
				placeholderText: i18nc("@info:placeholder", "Path to custom image…")

				rightActions: [
					Kirigami.Action {
						icon.name: "edit-clear"
						visible: imagePathTextField.text.length !== 0
						onTriggered: imagePathTextField.text = "";
					}
				]
			}
			Button {
				id: imageButton
				enabled: customRadio.checked

				icon.name: "document-open"

				ToolTip {
					visible: imageButton.hovered
					text: i18nc("@info:tooltip", "Choose image…")
				}

				onClicked: imagePicker.open()

				FileDialog {
					id: imagePicker

					title: i18nc("@title:window", "Choose an Image")
					currentFolder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
					nameFilters: [ i18n("Image Files (*.png *.jpg *.jpeg *.bmp *.svg *.svgz)") ]

					onAccepted: {
						imagePathTextField.text = selectedFile.toString().replace("file://", "")
					}
				}
			}
		}


		Item {
			Kirigami.FormData.label: i18n("Time between reminders")
			Kirigami.FormData.isSection: true
		}
		RowLayout {
			Layout.fillWidth: true
			//Kirigami.FormData.label: i18n("Time between reminders")

			// Label {
			// 	text: i18n("Hours: ")
			// }
			// SpinBox {
			// 	id: hoursInterval
			// 	value: root.hoursIntervalValue
			// 	from: 0
			// 	to: 24
			// 	editable: true
			// 	onValueChanged: cfg_hydroTime = hoursInterval.value * 3600 + minutesInterval.value * 60
			// }

			Label {
				text: i18n("Minutes: ")
			}
            SpinBox {
                id: minutesInterval
                value: minutesValue
                from: 0
                to: 999
                editable: true
                onValueChanged: cfg_hydroTime = minutesInterval.value * 60 * 1000
            }
		}

		Item {
			Kirigami.FormData.label: i18n("Animation Style")
			Kirigami.FormData.isSection: true
		}
		RadioButton {
			ButtonGroup.group: animRadioGroup
			text: i18n("Transparent-Opaque")
			checked: cfg_selAnimStyle === 0
			onToggled: if (checked) cfg_selAnimStyle = 0;
		}
		RadioButton {
			ButtonGroup.group: animRadioGroup
			text: i18n("Fill up")
			checked: cfg_selAnimStyle === 1
			onToggled: if (checked) cfg_selAnimStyle = 1;
		}
		RadioButton {
			ButtonGroup.group: animRadioGroup
			text: i18n("Drip")
			checked: cfg_selAnimStyle === 2
			onToggled: if (checked) cfg_selAnimStyle = 2;
		}

		RowLayout {
			id: checkboxGoku
			Layout.fillWidth: true

			Label {
				text: i18n("Pulse when expired: ")
			}
			CheckBox {
				id: pulseGoku
			}
		}


	}
}
