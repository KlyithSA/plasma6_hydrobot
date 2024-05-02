import QtQuick
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

import org.kde.plasma.core 2.0 as PlasmaCore
//import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.20 as Kirigami

PlasmoidItem {
	id: main
	preferredRepresentation: fullRepresentation

	property int hydroTimer: Plasmoid.configuration.hydroTime
	property int iconChoice: Plasmoid.configuration.selIcon
	property string customPath: Plasmoid.configuration.customImage
	property int animStyle: Plasmoid.configuration.selAnimStyle
	property bool animPulse: Plasmoid.configuration.selPulse
	property double animValue: 50.0
	property int animTick: 0


	// setting background as transparent with a drop shadow
	Plasmoid.backgroundHints: PlasmaCore.Types.ShadowBackground | PlasmaCore.Types.ConfigurableBackground

	fullRepresentation: MouseArea {
		id: rootBox

		onClicked: resetMain()

		Layout.minimumWidth: implicitWidth
		Layout.minimumHeight: implicitHeight
		Layout.preferredWidth: Layout.minimumWidth
		Layout.preferredHeight: Layout.minimumHeight

		Image {
			id: backgroundIcon
			// nested ternary
			source: { iconChoice ? (iconChoice < 2 ? "../img/drop-white.svg" : "../img/glass-white.svg") : customPath }
			fillMode: Image.PreserveAspectFit
			anchors.fill: parent
			visible: false
		}
		MultiEffect {
			source: backgroundIcon
			anchors.fill: backgroundIcon
			colorization: 1.0
			colorizationColor: Kirigami.Theme.highlightColor //"black"
			opacity: { animStyle===2 ? 0 : 0.088 }
		}

		Image {
			id: displayIcon
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			width: parent.width
			height: { animStyle===2 ? fillEffect(parent.height) : parent.height }
			opacity: opacityEffect()
			source: { iconChoice ? (iconChoice < 2 ? "../img/drop.svg" : "../img/glass.svg") : customPath }
			fillMode: Image.PreserveAspectFit
			visible: animStyle !== 1
		}
		// Qt5 opacity masking for "fill up" animation
		Item {
			id: maskSourceRect
			anchors.fill: parent
			visible: false
			Rectangle {
				//color: "white"
				anchors.top: parent.top
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width
				//windowshade effect
				height: { animStyle===1 ? parent.height - fillEffect(parent.height) : parent.height }
	            gradient: Gradient {
	                GradientStop { position: 0.0; color: "white" }
	                GradientStop { position: 0.9; color: "white"}
	                GradientStop { position: 1; color: { animTick ? "transparent" : "white"} }
	            }

			}
		}
		OpacityMask {
			anchors.fill: displayIcon
			cached: true
			source: displayIcon
			maskSource: maskSourceRect
			visible: animStyle===1
			opacity: opacityEffect()
			invert: true
		}

	}


	function opacityEffect() {
		if (animPulse && (animTick * 666 / hydroTimer > 1.08)) {
			return 0.95 - Math.abs(animTick % 10 - 5) / 9;
		} else {
			return animStyle ? 1 : Math.min( Math.pow(animTick * 666 / hydroTimer,3), 1);
		}
	}
	function fillEffect(inHeight) {
		if (!animStyle) {
			return inHeight;
		} else {
			return Math.min(inHeight * animTick * 666 / hydroTimer, inHeight)
		}
	}



	Timer {
		id: delayTimer
		interval: hydroTimer / 2
		running: true
		onTriggered: animateTimer.start()
	}
	Timer {
		id: animateTimer
		interval: 333
		repeat: true
		running: false
		onTriggered: { animTick++; }
	}


	function resetMain() {
		delayTimer.restart()
		animateTimer.stop()
		main.animTick = 0
	}

	function stopMain() {
		animateTimer.stop()
		delayTimer.stop()
		main.animValue = 0
		main.animTick = 0
	}


	Plasmoid.contextualActions: [
		PlasmaCore.Action {
			text: "Reset Timer"
			onTriggered: resetMain()
		},
		PlasmaCore.Action {
			text: "Stop Timer"
			onTriggered: stopMain()
		}
		]
	}

