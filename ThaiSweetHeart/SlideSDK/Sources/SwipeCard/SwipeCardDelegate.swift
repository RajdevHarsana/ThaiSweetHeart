

import Foundation

protocol SwipeCardDelegate: AnyObject {
  func card(didBeginSwipe card: SwipeCard)
  func card(didCancelSwipe card: SwipeCard)
  func card(didContinueSwipe card: SwipeCard)
  func card(didSwipe card: SwipeCard, with direction: SwipeDirection)
  func card(didTap card: SwipeCard)
}
