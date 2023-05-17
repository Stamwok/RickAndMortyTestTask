

import Foundation
import NeedleFoundation

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Traversal Helpers

private func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

// MARK: - Providers

#if !NEEDLE_DYNAMIC

private class CharacterInfoDependencye4c8c6da51090589b44dProvider: CharacterInfoDependency {
    var apiService: RickAndMortyApiProtocol {
        return characterListComponent.apiService
    }
    private let characterListComponent: CharacterListComponent
    init(characterListComponent: CharacterListComponent) {
        self.characterListComponent = characterListComponent
    }
}
/// ^->CharacterListComponent->CharacterInfoComponent
private func factoryc3d398dcc7305c18ef4133b33bdc2ba96cc69ca7(_ component: NeedleFoundation.Scope) -> AnyObject {
    return CharacterInfoDependencye4c8c6da51090589b44dProvider(characterListComponent: parent1(component) as! CharacterListComponent)
}

#else
extension CharacterInfoComponent: Registration {
    public func registerItems() {
        keyPathToName[\CharacterInfoDependency.apiService] = "apiService-RickAndMortyApiProtocol"
    }
}
extension CharacterListComponent: Registration {
    public func registerItems() {


    }
}


#endif

private func factoryEmptyDependencyProvider(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EmptyDependencyProvider(component: component)
}

// MARK: - Registration
private func registerProviderFactory(_ componentPath: String, _ factory: @escaping (NeedleFoundation.Scope) -> AnyObject) {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: componentPath, factory)
}

#if !NEEDLE_DYNAMIC

@inline(never) private func register1() {
    registerProviderFactory("^->CharacterListComponent->CharacterInfoComponent", factoryc3d398dcc7305c18ef4133b33bdc2ba96cc69ca7)
    registerProviderFactory("^->CharacterListComponent", factoryEmptyDependencyProvider)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
