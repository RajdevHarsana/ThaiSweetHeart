
import Foundation

public protocol SwipeCardStackDataSource: AnyObject {
  func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard
  func numberOfCards(in cardStack: SwipeCardStack) -> Int
}
