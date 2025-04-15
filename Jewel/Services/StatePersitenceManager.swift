//
//  StatePersitenceManager.swift
//  Stacks
//
//  Created by Greg Hepworth on 29/08/2023.
//  Copyright © 2023 Breakbeat Ltd. All rights reserved.
//

import Foundation

enum StatePersitenceManager {
  
  static func save(_ state: AppState) {
    do {
      let encoder = JSONEncoder()
      encoder.keyEncodingStrategy = .convertToSnakeCase
      let encodedState = try encoder.encode(state)
      UserDefaults.standard.set(encodedState, forKey: AppState.versionKey)
    } catch {
      JewelLogger.persistence.debug("💎 Persistence > Error saving state: \(error.localizedDescription)")
    }
  }
  
  static func load() -> AppState {
    
    StateMigrations.runMigrations()
    
    return savedState() ?? newState()
    
  }
  
  static func savedState() -> AppState? {
    
    JewelLogger.persistence.info("💎 Persistence > Looking for a current saved state")
    guard let savedState = UserDefaults.standard.object(forKey: AppState.versionKey) as? Data else {
      JewelLogger.persistence.info("💎 Persistence > No current saved state found")
      return nil
    }
    
    JewelLogger.persistence.info("💎 Persistence > Found a current saved state")
    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      var state = try decoder.decode(AppState.self, from: savedState)
      state.navigation.onRotationId = state.library.onRotation.id
      state.navigation.activeStackId = state.library.onRotation.id
      JewelLogger.persistence.info("💎 Persistence > Loaded a current saved state")
      return state
    } catch {
      JewelLogger.persistence.debug("💎 Persistence > Error decoding a current saved state: \(error.localizedDescription)")
      return nil
    }
    
  }
  
  static func newState() -> AppState {
    
    JewelLogger.persistence.info("💎 Persistence > Creating a new state")
    let onRotationStack = Stack(name: Navigation.Tab.onRotation.rawValue)
    let library = Library(onRotation: onRotationStack, stacks: [Stack]())
    var state = AppState(settings: Settings(), library: library)
    state.navigation.onRotationId = onRotationStack.id
    state.navigation.activeStackId = onRotationStack.id
    JewelLogger.persistence.info("💎 Persistence > Created a new state")
    return state
  }
  
  struct StateMigrations {
    
    fileprivate static func runMigrations() {
      migrate_v2_0_to_v2_1()
      migrate_v2_1_to_v3_0()
      
      UserDefaults.standard.synchronize()
    }
    
    private static func migrate_v2_1_to_v3_0() {
      
      JewelLogger.persistence.info("💎 Persistence > Looking for a v2.1 saved state")
      guard let v2_1_StateData = UserDefaults.standard.object(forKey: AppState_v2_1.versionKey) as? Data else {
        JewelLogger.persistence.info("💎 Persistence > No v2.1 saved state found")
        return
      }
      
      JewelLogger.persistence.info("💎 Persistence > Found a v2.1 saved state, migrating to v3.0")
      
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let v2_1_State = try decoder.decode(AppState_v2_1.self, from: v2_1_StateData)
        
        let migratedSettings = Settings(preferredMusicPlatform: v2_1_State.settings.preferredMusicPlatform, firstTimeRun: false)
        
        var migratedOnRotationSlots = [Slot]()
        for oldSlot in v2_1_State.library.onRotation.slots {
          let migratedSlot = Slot(id: oldSlot.id,
                                  album: oldSlot.album,
                                  playbackLinks: oldSlot.playbackLinks)
          migratedOnRotationSlots.append(migratedSlot)
        }
        
        let migratedOnRotationStack = Stack(id: v2_1_State.library.onRotation.id,
                                            name: v2_1_State.library.onRotation.name,
                                            slots: migratedOnRotationSlots)
        
        var migratedLibraryStacks = [Stack]()
        for oldCollection in v2_1_State.library.collections {
          var migratedCollectionSlots = [Slot]()
          for oldSlot in oldCollection.slots {
            let migratedSlot = Slot(id: oldSlot.id,
                                    album: oldSlot.album,
                                    playbackLinks: oldSlot.playbackLinks)
            migratedCollectionSlots.append(migratedSlot)
          }
          
          let migratedStack = Stack(id: oldCollection.id,
                                    name: oldCollection.name,
                                    slots: migratedCollectionSlots)
          migratedLibraryStacks.append(migratedStack)
        }
        
        let migratedLibrary = Library(onRotation: migratedOnRotationStack,
                                      stacks: migratedLibraryStacks)
        
        let v3_0_State = AppState(settings: migratedSettings,
                                  library: migratedLibrary)
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let encodedState = try encoder.encode(v3_0_State)
        UserDefaults.standard.set(encodedState, forKey: AppState.versionKey)
        
        JewelLogger.persistence.info("💎 Persistence > Migration successful, deleting v2.1 saved state")
        UserDefaults.standard.removeObject(forKey: AppState_v2_1.versionKey)
        
        UserDefaults.standard.synchronize()
        
      } catch {
        JewelLogger.persistence.debug("💎 Persistence > Error migrating a v2.1 state: \(error.localizedDescription)")
        // Something's gone wrong and we haven't handled it, but now a new state will be created and take precedence
        // so to avoid future problems we should remove the remnants of the old state.
        UserDefaults.standard.removeObject(forKey: AppState_v2_1.versionKey)
      }
      
    }
    
    private static func migrate_v2_0_to_v2_1() {
      
      JewelLogger.persistence.info("💎 Persistence > Looking for a v2.0 saved state")
      
      guard let v2_0_StateData = UserDefaults.standard.object(forKey: AppState_v2_0.versionKey) as? Data else {
        JewelLogger.persistence.info("💎 Persistence > No v2.0 saved state found")
        return
      }
      
      JewelLogger.persistence.info("💎 Persistence > Found a v2.0 saved state, migrating to v2.1")
      
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let v2_0_State = try decoder.decode(AppState_v2_0.self, from: v2_0_StateData)
        
        let migratedSettings = AppState_v2_1.Settings(preferredMusicPlatform: OdesliPlatform.allCases[v2_0_State.settings.preferredMusicPlatform],
                                                      firstTimeRun: false)
        
        var migratedOnRotationSlots = [AppState_v2_1.Slot]()
        for oldSlot in v2_0_State.library.onRotation.slots {
          let migratedSlot = AppState_v2_1.Slot(id: oldSlot.id,
                                                album: oldSlot.album,
                                                playbackLinks: oldSlot.playbackLinks)
          migratedOnRotationSlots.append(migratedSlot)
        }
        
        let migratedOnRotationCollection = AppState_v2_1.Collection(id: v2_0_State.library.onRotation.id,
                                                                    name: v2_0_State.library.onRotation.name,
                                                                    slots: migratedOnRotationSlots)
        
        var migratedLibraryCollections = [AppState_v2_1.Collection]()
        for oldCollection in v2_0_State.library.collections {
          var migratedCollectionSlots = [AppState_v2_1.Slot]()
          for oldSlot in oldCollection.slots {
            let migratedSlot = AppState_v2_1.Slot(id: oldSlot.id,
                                                  album: oldSlot.album,
                                                  playbackLinks: oldSlot.playbackLinks)
            migratedCollectionSlots.append(migratedSlot)
          }
          let migratedCollection = AppState_v2_1.Collection(id: oldCollection.id,
                                                            name: oldCollection.name,
                                                            slots: migratedCollectionSlots)
          migratedLibraryCollections.append(migratedCollection)
        }
        
        let migratedLibrary = AppState_v2_1.Library(onRotation: migratedOnRotationCollection,
                                                    collections: migratedLibraryCollections)
        
        let v2_1_State = AppState_v2_1(settings: migratedSettings,
                                       library: migratedLibrary)
        
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let encodedState = try encoder.encode(v2_1_State)
        UserDefaults.standard.set(encodedState, forKey: AppState_v2_1.versionKey)
        
        JewelLogger.persistence.info("💎 Persistence > Migration successful, deleting v2.0 saved state")
        UserDefaults.standard.removeObject(forKey: AppState_v2_0.versionKey)
        
        UserDefaults.standard.synchronize()
        
      } catch {
        JewelLogger.persistence.debug("💎 Persistence > Error migrating a v2.0 state: \(error.localizedDescription)")
        // Something's gone wrong and we haven't handled it, but now a new state will be created and take precedence
        // so to avoid future problems we should remove the remnants of the old state.
        UserDefaults.standard.removeObject(forKey: AppState_v2_0.versionKey)
      }
      
    }
  }
  
}
