import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // Проверяем, авторизован ли пользователь
        let isLoggedIn = AuthService.shared.isLoggedIn()
        
        let rootViewController: UIViewController
        
        if isLoggedIn {
            // Показываем главный экран с табами
            rootViewController = createMainTabBarController()
        } else {
            // Показываем экран входа
            rootViewController = UINavigationController(rootViewController: LoginViewController())
        }
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
    func createMainTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        // Заказы
        let ordersVC = OrdersViewController()
        let ordersNav = UINavigationController(rootViewController: ordersVC)
        ordersNav.tabBarItem = UITabBarItem(
            title: "Заказы",
            image: UIImage(systemName: "doc.text"),
            selectedImage: UIImage(systemName: "doc.text.fill")
        )
        
        // Статистика
        let statisticsVC = StatisticsViewController()
        let statisticsNav = UINavigationController(rootViewController: statisticsVC)
        statisticsNav.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "chart.bar"),
            selectedImage: UIImage(systemName: "chart.bar.fill")
        )
        
        // Профиль
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        tabBarController.viewControllers = [ordersNav, statisticsNav, profileNav]
        
        return tabBarController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
