//
//  SceneDelegate.swift
//  INT
//
//  Created by yuehuig on 2021/8/19.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    /// 后台运行
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: -999)
    /// 后台运行timer
    private var backTimer: Timer?
    /// 后台运行倒计时变量
    private var backTime: TimeInterval = kBackgroundRunTime
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.frame = windowScene.coordinateSpace.bounds
        window?.backgroundColor = .white
        let nav = YHNavigationController(rootViewController: HomeController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        backTime = kBackgroundRunTime
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            self.endBackgroundTask()
        })
        backTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(backGroundTask(timer:)),
                                         userInfo: nil,
                                         repeats: true)
    }

    func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String) {
        printLog(#function)
    }
    
    override func updateUserActivityState(_ activity: NSUserActivity) {
        printLog(#function)
    }
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        printLog(#function)
        return nil
    }
    
    override func restoreUserActivityState(_ activity: NSUserActivity) {
        printLog(#function)
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        printLog(#function)
        let nav = window?.rootViewController as? UINavigationController
        let v = UIViewController()
        v.view.backgroundColor = .red
        nav?.pushViewController(v, animated: true)
    }
    
    func scene(_ scene: UIScene, didUpdate userActivity: NSUserActivity) {
        printLog(#function)
    }
    
    func scene(_ scene: UIScene, restoreInteractionStateWith stateRestorationActivity: NSUserActivity) {
        printLog(#function)
    }
    
    /// 后台任务处理
    @objc private func backGroundTask(timer: Timer) {
        backTime -= 1
        if backTime == 0 {
            endBackgroundTask()
        }
        let backgroundTimeRemaining = UIApplication.shared.backgroundTimeRemaining
        printLog(String(format: "Background Timer Remaining -- %.02f", backgroundTimeRemaining))
    }
    
    /// 结束后台任务
    private func endBackgroundTask() {
        backTimer?.invalidate()
        backTimer = nil
        if backgroundTaskIdentifier != UIBackgroundTaskIdentifier.invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
        }
        backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    }
}

