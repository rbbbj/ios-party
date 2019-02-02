import Reachability
import RxSwift

final class Network {
    private var isOnline: Bool  {
        if let reachability = Reachability(), reachability.connection != .none {
            return true
        }
        return false
    }
    
    /**
     Obtain servers.
     
     - returns: Single observable with array of server objects.
     */
    func retrieveAllServers() -> Single<[Server]> {
        return Single.create{ [isOnline] observer in
            if !isOnline {
                return Disposables.create {}
            } else {
                guard let accessToken = UserSession.shared.token else {
                    return Disposables.create {}
                }

                HTTPClient().loadData(from: URLs.Tesonet.dataURL, with: accessToken) { result, error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    guard let result = result else {
                        observer(.error(DataError.unknownError))
                        return
                    }
                    RealmStore.shared.add(items: result)
                    observer(.success(result))
                }
            }
            
            return Disposables.create {}
        }
    }
    
    /**
     Obtain token.
     
     - parameter params: structure holding login data - username and password.
     - returns: Single observable with token.
     */
    func retrieveToken(with params: LoginData) -> Single<String> {
        return Single.create{ [isOnline] observer in
            if !isOnline {
                return Disposables.create {}
            } else {
                HTTPClient()
                    .loadToken(from: URLs.Tesonet.tokenURL,
                               withParams: params.toJson()) { result, error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    guard let result = result else {
                        observer(.error(DataError.unknownError))
                        return
                    }
                    observer(.success(result))
                }
            }
            
            return Disposables.create {}
        }
    }
}
