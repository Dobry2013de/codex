import React from 'react';
import { View, Text, ScrollView, TouchableOpacity } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useStore } from '../store/useStore';
import { getI18nText } from '../utils/i18n';
import { Plus } from 'lucide-react-native';

const ProjectsScreen = () => {
  const { lang } = useStore();
  const t = (key) => getI18nText(lang, key);

  return (
    <SafeAreaView className="flex-1 bg-app-bg">
      <ScrollView className="p-4">
        <Text className="text-2xl font-bold text-text-main mb-4">{t('hdrProjects')}</Text>
        <Text className="text-text-muted mb-6">{t('subProjects')}</Text>

        <TouchableOpacity className="p-3 rounded-xl bg-primary flex-row items-center justify-center mb-6">
          <Plus size={18} color="white" />
          <Text className="text-white font-bold ml-2">{t('hdrAddProject')}</Text>
        </TouchableOpacity>

        <View className="bg-card-bg p-4 rounded-xl border border-border">
          <Text className="text-text-main font-bold mb-2">Project List Placeholder</Text>
          <Text className="text-text-muted">Full project management UI is complex and omitted for this initial translation. See PWA source for full logic.</Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

export default ProjectsScreen;
