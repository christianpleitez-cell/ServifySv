import UIKit

class MainTabBarController: UITabBarController {

    private let isProfessional = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        tabBar.tintColor = .systemBlue
    }

    private func setupTabs() {
        if isProfessional {
            setupProfessionalTabs()
        } else {
            setupClientTabs()
        }
    }

    private func setupClientTabs() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Inicio", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))

        let solicitudesVC = UINavigationController(rootViewController: SolicitudesViewController())
        solicitudesVC.tabBarItem = UITabBarItem(title: "Solicitudes", image: UIImage(systemName: "list.bullet.clipboard"), selectedImage: UIImage(systemName: "list.bullet.clipboard.fill"))

        let chatVC = UINavigationController(rootViewController: ChatsListViewController())
        chatVC.tabBarItem = UITabBarItem(title: "Mensajes", image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))

        let historialVC = UINavigationController(rootViewController: HistorialViewController())
        historialVC.tabBarItem = UITabBarItem(title: "Historial", image: UIImage(systemName: "clock"), selectedImage: UIImage(systemName: "clock.fill"))

        let perfilVC = UINavigationController(rootViewController: ClienteProfileViewController())
        perfilVC.tabBarItem = UITabBarItem(title: "Perfil", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))

        viewControllers = [homeVC, solicitudesVC, chatVC, historialVC, perfilVC]
    }

    private func setupProfessionalTabs() {
        let homeVC = UINavigationController(rootViewController: ProfesionalHomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Inicio", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))

        let solicitudesVC = UINavigationController(rootViewController: SolicitudesViewController())
        solicitudesVC.tabBarItem = UITabBarItem(title: "Solicitudes", image: UIImage(systemName: "list.bullet.clipboard"), selectedImage: UIImage(systemName: "list.bullet.clipboard.fill"))

        let publicarVC = UINavigationController(rootViewController: PublicarViewController())
        publicarVC.tabBarItem = UITabBarItem(title: "Publicar", image: UIImage(systemName: "plus.circle"), selectedImage: UIImage(systemName: "plus.circle.fill"))

        let historialVC = UINavigationController(rootViewController: HistorialViewController())
        historialVC.tabBarItem = UITabBarItem(title: "Historial", image: UIImage(systemName: "clock"), selectedImage: UIImage(systemName: "clock.fill"))

        let perfilVC = UINavigationController(rootViewController: ClienteProfileViewController())
        perfilVC.tabBarItem = UITabBarItem(title: "Perfil", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))

        viewControllers = [homeVC, solicitudesVC, publicarVC, historialVC, perfilVC]
    }
}
