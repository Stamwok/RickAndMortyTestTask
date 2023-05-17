//
//  UIVIewController+Router.swift
//  RickAndMortyMVVM+Combine
//
//  Created by Егор Шуляк on 16.04.23.
//

import Foundation
import RouteComposer
import UIKit
import os.log

extension UIViewController {

    // This class is needed just for the test purposes
    private final class TestInterceptor: RoutingInterceptor {
        let logger: RouteComposer.Logger?
        let message: String

        init(_ message: String) {
            self.logger = RouteComposerDefaults.shared.logger
            self.message = message
        }

        func perform(with context: Any?, completion: @escaping (RoutingResult) -> Void) {
            logger?.log(.info(message))
            completion(.success)
        }
    }

    static let router: Router = {
        var defaultRouter = GlobalInterceptorRouter(router: FailingRouter(router: DefaultRouter()))
        defaultRouter.addGlobal(TestInterceptor("Global interceptors start"))
        defaultRouter.addGlobal(NavigationDelayingInterceptor(strategy: .wait))
        defaultRouter.add(TestInterceptor("Router interceptors start"))
        return AnalyticsRouterDecorator(router: defaultRouter)
    }()

    var router: Router {
        UIViewController.router
    }

}
