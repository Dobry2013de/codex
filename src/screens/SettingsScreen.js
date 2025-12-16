import React, { useState } from 'react';
import { View, Text, ScrollView, TextInput, TouchableOpacity, Switch, Alert } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useStore } from '../store/useStore';
import { getI18nText } from '../utils/i18n';
import { clearData } from '../utils/data-management';
import Toast from 'react-native-toast-message';

const SettingsScreen = () => {
  const { lang, conf, updateConf, persist } = useStore();
  const t = (key) => getI18nText(lang, key);

  const [localConf, setLocalConf] = useState(conf);

  const handleChange = (key, value) => {
    setLocalConf(prev => ({ ...prev, [key]: value }));
  };

  const saveSettings = () => {
    updateConf(localConf);
    persist();
    Toast.show({ type: 'success', text1: t('msgProfileSaved') || 'Ustawienia zapisane!' });
  };

  const renderSection = (titleKey, fields) => (
    <View className="profile-section mb-6 p-4 bg-card-bg rounded-xl border border-border">
      <Text className="text-sm font-bold text-text-main uppercase mb-4">{t(titleKey)}</Text>
      {fields.map((field, index) => (
        <View key={index} className="mb-4">
          <Text className="text-xs uppercase text-text-muted font-bold mb-1">{t(field.labelKey)}</Text>
          {field.type === 'text' && (
            <TextInput
              className="bg-input-bg border border-border text-text-main p-3 rounded-xl text-base"
              value={localConf[field.key]}
              onChangeText={(text) => handleChange(field.key, text)}
              placeholder={field.placeholderKey ? t(field.placeholderKey) : ''}
            />
          )}
          {field.type === 'switch' && (
            <View className="flex-row justify-between items-center bg-input-bg border border-border p-3 rounded-xl">
              <Text className="text-text-main">{t(field.labelKey)}</Text>
              <Switch
                value={localConf[field.key]}
                onValueChange={(value) => handleChange(field.key, value)}
                trackColor={{ false: "#767577", true: "#3b82f6" }}
                thumbColor={localConf[field.key] ? "#f4f3f4" : "#f4f3f4"}
              />
            </View>
          )}
          {field.type === 'textarea' && (
            <TextInput
              className="bg-input-bg border border-border text-text-main p-3 rounded-xl text-base h-24"
              value={localConf[field.key]}
              onChangeText={(text) => handleChange(field.key, text)}
              multiline
            />
          )}
        </View>
      ))}
    </View>
  );

  const basicFields = [
    { key: 'first', labelKey: 'lblUserFirst', type: 'text' },
    { key: 'last', labelKey: 'lblUserLast', type: 'text' },
    { key: 'birthDate', labelKey: 'lblBirthDate', type: 'text', placeholderKey: 'phBirthDate' },
    { key: 'citizenship', labelKey: 'lblCitizenship', type: 'text' },
    { key: 'bsn', labelKey: 'lblBSN', type: 'text' },
    { key: 'idNumber', labelKey: 'lblIDNumber', type: 'text' },
    { key: 'address', labelKey: 'lblAddress', type: 'textarea' },
    { key: 'phone', labelKey: 'lblPhone', type: 'text' },
    { key: 'email', labelKey: 'lblEmail', type: 'text' },
  ];

  const transportFields = [
    { key: 'driverLicense', labelKey: 'lblDriverLicense', type: 'switch' },
    { key: 'ownTransport', labelKey: 'lblOwnTransport', type: 'switch' },
  ];

  const businessFields = [
    { key: 'vca', labelKey: 'lblVCA', type: 'switch' },
    { key: 'vcaNumber', labelKey: 'lblVCANumber', type: 'text' },
    { key: 'vcaExpiry', labelKey: 'lblVCAExpiry', type: 'text' },
    { key: 'vcaAdded', labelKey: 'lblVCAAdded', type: 'text' },
    { key: 'gpi', labelKey: 'lblGPI', type: 'switch' },
    { key: 'kvk', labelKey: 'lblKVK', type: 'switch' },
    { key: 'kvkNumber', labelKey: 'lblKVKNumber', type: 'text' },
    { key: 'btw', labelKey: 'lblBTW', type: 'switch' },
    { key: 'btwNumber', labelKey: 'lblBTWNumber', type: 'text' },
  ];

  const appSettingsFields = [
    { key: 'start', labelKey: 'lblDefStart', type: 'text' },
    { key: 'end', labelKey: 'lblDefEnd', type: 'text' },
  ];

  return (
    <SafeAreaView className="flex-1 bg-app-bg">
      <ScrollView className="p-4 mb-20">
        <Text className="text-2xl font-bold text-text-main mb-4">{t('hdrSet')}</Text>

        {renderSection('lblPersonalBasic', basicFields)}
        {renderSection('lblPersonalTransport', transportFields)}
        {renderSection('lblPersonalBusiness', businessFields)}
        {renderSection('lblAppSettings', appSettingsFields)}

        <View className="mb-6 p-4 bg-card-bg rounded-xl border border-border">
          <Text className="text-sm font-bold text-text-main uppercase mb-4">{t('lblPersonalNote')}</Text>
          <TextInput
            className="bg-input-bg border border-border text-text-main p-3 rounded-xl text-base h-24"
            value={localConf.personalNote}
            onChangeText={(text) => handleChange('personalNote', text)}
            multiline
          />
        </View>

        <TouchableOpacity onPress={saveSettings} className="p-4 rounded-xl bg-primary shadow-primary-glow mb-4">
          <Text className="text-white text-center font-extrabold uppercase tracking-wider">{t('btnSaveSettings')}</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={clearData} className="p-4 rounded-xl bg-danger/10 border border-danger/50 mb-4">
          <Text className="text-danger text-center font-extrabold uppercase tracking-wider">{t('btnReset')}</Text>
        </TouchableOpacity>
      </ScrollView>
    </SafeAreaView>
  );
};

export default SettingsScreen;
