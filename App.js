import React, { useEffect, useState } from 'react';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { StatusBar } from 'expo-status-bar';
import { View, Text, ActivityIndicator } from 'react-native';
import Navigation from './src/navigation/Navigation';
import { useStore } from './src/store/useStore';
import { initDatabase } from './src/database/database';
import { applyTheme } from './src/utils/theme';
import { applyLang } from './src/utils/i18n';

export default function App() {
  const [isReady, setIsReady] = useState(false);
  const { loadFromStorage, lang, theme } = useStore();

  useEffect(() => {
    async function prepare() {
      try {
        // Initialize database and load persisted state
        await initDatabase();
        await loadFromStorage();
        
        // Apply theme and language settings from store
        applyTheme(theme);
        applyLang(lang);

        setIsReady(true);
      } catch (e) {
        console.warn(e);
        setIsReady(true);
      }
    }
    prepare();
  }, []);

  if (!isReady) {
    return (
      <View className="flex-1 bg-app-bg justify-center items-center">
        <ActivityIndicator size="large" color="#3b82f6" />
        <Text className="text-white mt-4 text-lg">Loading BreboTeam...</Text>
      </View>
    );
  }

  return (
    <SafeAreaProvider>
      <StatusBar style={theme === 'light' ? 'dark' : 'light'} />
      <Navigation />
    </SafeAreaProvider>
  );
}
