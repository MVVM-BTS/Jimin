//
//  MoviesSearchFlowCoordinator.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 03.03.19.
//

import UIKit

protocol MoviesSearchFlowCoordinatorDependencies  {
    func makeMoviesListViewController(actions: MoviesListViewModelActions) -> MoviesListViewController
    func makeMoviesDetailsViewController(movie: Movie) -> UIViewController
    func makeMoviesQueriesSuggestionsListViewController(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> UIViewController
}

/* Coordinator : Swift의 디자인 패턴
 - ViewController의 책임을 줄이기 위한 패턴.
 - 어떤 책임? 화면 전환 관련 책임.
 - 어떻게? 각 뷰별 담당 Coordinator & Main Coordinator가 있다. 화면 전환을 하고 싶을 때 뷰별 Coordinator가 Main Coordinator에게 화면 전환 요청을 보내면 Main Coordinator가 그 응답으로 화면 전환 해줌.
 */
final class MoviesSearchFlowCoordinator {
    
    //0. Main Coordinator는 네비게이션 스택을 쌓을 UINavigationController 타입의 변수 가짐.
    private weak var navigationController: UINavigationController?
    private let dependencies: MoviesSearchFlowCoordinatorDependencies

    private weak var moviesListVC: MoviesListViewController?
    private weak var moviesQueriesSuggestionsVC: UIViewController?

    //1. 초기화 진행
    init(navigationController: UINavigationController,
         dependencies: MoviesSearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    //0. Main Coordinator는 로직을 수행할 메서드를 가짐.
    // 호출은 AppDelegate에서 된다. 
    func start() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        
        //???: 화면 전환 하나 하는 데에도 protocol을 만들고 ViewModel에서 struct를 만들어 관리, 수행하는 게 신기하다.
        let actions = MoviesListViewModelActions(showMovieDetails: showMovieDetails,
                                                 showMovieQueriesSuggestions: showMovieQueriesSuggestions,
                                                 closeMovieQueriesSuggestions: closeMovieQueriesSuggestions)
        let vc = dependencies.makeMoviesListViewController(actions: actions)

        //2. 첫 번째 뷰컨 띄움.
        navigationController?.pushViewController(vc, animated: false)
        moviesListVC = vc
    }

    //MARK: 뷰컨 이동 actions에 들어가는 함수들
    private func showMovieDetails(movie: Movie) {
        let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showMovieQueriesSuggestions(didSelect: @escaping (MovieQuery) -> Void) {
        guard let moviesListViewController = moviesListVC, moviesQueriesSuggestionsVC == nil,
            let container = moviesListViewController.suggestionsListContainer else { return }

        let vc = dependencies.makeMoviesQueriesSuggestionsListViewController(didSelect: didSelect)
        
        //???: 컨테이너는 그냥 뷰인 것 같은데 어떻게,왜 뷰안에 뷰컨을 넣는 건지 이해를 못한 것 같아요
        moviesListViewController.add(child: vc, container: container)
        moviesQueriesSuggestionsVC = vc
        container.isHidden = false
    }

    private func closeMovieQueriesSuggestions() {
        moviesQueriesSuggestionsVC?.remove()
        moviesQueriesSuggestionsVC = nil
        moviesListVC?.suggestionsListContainer.isHidden = true
    }
}
