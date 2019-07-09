
import Foundation

class AppLanguageManager{

    
    //MARK: - Propreties  AppLanguageManager.shared.currentLanguage

	
    /// Gets the current app language.
    /// Please use this throughout the app
    public var currentLanguage: Language = .en
   
    /// Shared instance
    public static var shared = AppLanguageManager()
	
	
    public var savedLanguage: Language {
        guard let langs = UserDefaults.standard.stringArray(forKey: "AppleLanguages") else{
            return .en
        }
        return langs[0].contains("ar") ? .ar : .en
    }
    
    //////////////////////////////////

	
	//MARK: - Initializers
	
    
    private init() {
        guard let langs = UserDefaults.standard.stringArray(forKey: "AppleLanguages") else{
            currentLanguage = .en
            return
        }
        currentLanguage = langs[0].contains("ar") ? .ar : .en
    }
	
    
    //////////////////////////////////

	
    //MARK: - Public Methods
	
	
    /// Changes app langauge
    ///
    /// - Parameter lang: Language enum
    func changeLanguage(lang: Language){
        UserDefaults.standard.removeObject(forKey: "AppleLanguages")
        UserDefaults.standard.set([lang.name], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
    }
	
    
    //////////////////////////////////
	

    //MARK: - Language Enum
	
	
    enum Language{
        case ar
        case en
        var name: String{
            switch self {
            case .ar:
                return "ar"
            case .en:
                return "en"
            }
        }
        
        var id: Int{
            switch self {
            case .ar:
                return 1
            case .en:
                return 2
            }
        }
    }
    
}
