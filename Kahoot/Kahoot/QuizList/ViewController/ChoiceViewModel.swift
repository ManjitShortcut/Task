import Foundation
import UIKit

enum ChoicePositionDirection {
    case left
    case right
}

enum ChoiceState {
    case timeOut
    case normal
    case selectChoice
}

class ChoiceViewModel: Identifiable, Hashable {
    
    let id = UUID()
    let choice: Choice
    let position: Int
    
    /// when user selected one of the option
    var state = ChoiceState.normal
    var didUserSelectOption = false

    init(choice: Choice,
         position: Int) {
        self.choice = choice
        self.position = position
    }
    
    static func == (lhs: ChoiceViewModel, rhs: ChoiceViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func getChoicePositionDirection() -> ChoicePositionDirection {
        switch position {
        case 0:
            return .left
        case 1:
            return .right
        case 2:
            return .left
        case 3:
            return .right
        default:
            return .left
        }
    }
    
    func getImageShapeForPosition() -> UIImage? {
        switch position {
        case 0:
            return Asset.Figma.Shape.shapeTrangle.image
        case 1:
            return Asset.Figma.Shape.shapeDiamond.image
        case 2:
            return Asset.Figma.Shape.shapeCircle.image
        case 3:
            return Asset.Figma.Shape.shapeSquare.image
        default:
            return nil
        }
    }
     
    func getBackgroundColorForPosition() -> UIColor? {

        switch position {
        case 0:
            return Color.radicalRed.color
        case 1:
            return Color.blue.color
        case 2:
            return Color.yellow.color
        case 3:
            return Color.darkGreen.color
        default:
            return nil
        }
    }
    
    func getChoiceStatusBackgroundColor() -> UIColor? {
        
        if choice.correct {
            return Color.green.color
        } else {
            return Color.pink.color
        }
    }
    
    func getChoiceStatusIcon() -> UIImage? {
        if choice.correct {
            return Asset.Figma.Correct.correct.image
        } else {
            return Asset.Figma.Wrong.wrong.image
        }
    }
}

enum Section {
    case choice
}
