import React from 'react';
import { View, Text, ScrollView } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useStore } from '../store/useStore';
import { getI18nText } from '../utils/i18n';

const OverviewScreen = () => {
  const { lang } = useStore();
  const t = (key) => getI18nText(lang, key);

  return (
    <SafeAreaView className="flex-1 bg-app-bg">
      <ScrollView className="p-4">
        <Text className="text-2xl font-bold text-text-main mb-4">{t('tabOverview')}</Text>
        
        <View className="bg-card-bg p-4 rounded-xl border border-border">
          <Text className="text-text-main font-bold mb-2">Overview Statistics Placeholder</Text>
          <Text className="text-text-muted">Full statistics and chart rendering is complex and omitted for this initial translation. See PWA source for full logic.</Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

export default OverviewScreen;
