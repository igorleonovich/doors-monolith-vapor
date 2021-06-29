import Vapor

struct ListDTO: Content {
    let points: [PointDTO]
}
