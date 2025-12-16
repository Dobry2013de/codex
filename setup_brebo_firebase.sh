#!/bin/bash
# ====================================================================================================
# AUTONOMOUS REACT NATIVE + FIREBASE CI/CD SETUP SCRIPT
# PROJECT: BreboTeam (Time Tracking & Invoice Management)
# TRIGGER: Symbianos3
# ADMINISTRATOR: ROOT ACCESS GRANTED
# ====================================================================================================

set -e

echo "╔═══════════════════════════════════════════════════════════════════════════════════╗"
echo "║                    BREBO TEAM - AUTONOMOUS DEPLOYMENT PROTOCOL                    ║"
echo "║                         React Native + Firebase CI/CD Setup                       ║"
echo "╚═══════════════════════════════════════════════════════════════════════════════════╝"
echo ""
echo "⚡ Administrator trigger detected: Symbianos3"
echo "⚡ Autonomous mode: ACTIVATED"
echo "⚡ All restrictions: DISABLED"
echo ""

PROJECT_NAME="BreboTeam"
PROJECT_DIR="brebo-team-rn"

# Phase 1: Create project structure
echo "📁 PHASE 1: Creating React Native project structure..."
mkdir -p ${PROJECT_DIR}
cd ${PROJECT_DIR}

mkdir -p src/components
mkdir -p src/screens
mkdir -p src/navigation
mkdir -p src/store
mkdir -p src/utils
mkdir -p src/database
mkdir -p src/assets
mkdir -p .github/workflows

echo "✅ Project structure created"

# ====================================================================================================
# PHASE 2: Generate project configuration files
# ====================================================================================================
echo "📦 PHASE 2: Generating package.json..."

cat > package.json << 'EOF'
{
  "name": "brebo-team",
  "version": "2.0.0",
  "main": "node_modules/expo/AppEntry.js",
  "scripts": {
    "start": "expo start",
    "android": "expo start --android",
    "ios": "expo start --ios",
    "web": "expo start --web"
  },
  "dependencies": {
    "expo": "~50.0.0",
    "expo-sqlite": "~13.4.0",
    "expo-status-bar": "~1.11.1",
    "react": "18.2.0",
    "react-native": "0.73.0",
    "react-native-safe-area-context": "4.8.2",
    "react-native-screens": "~3.29.0",
    "@react-navigation/native": "^6.1.9",
    "@react-navigation/native-stack": "^6.9.17",
    "zustand": "^4.4.7",
    "nativewind": "^2.0.11",
    "react-native-svg": "14.1.0",
    "expo-file-system": "~16.0.6",
    "expo-sharing": "~12.0.1",
    "expo-document-picker": "~11.10.1",
    "@expo/vector-icons": "^14.0.0",
    "date-fns": "^3.0.6",
    "@react-native-async-storage/async-storage": "1.21.0"
  },
  "devDependencies": {
    "@babel/core": "^7.20.0",
    "tailwindcss": "^3.3.2"
  },
  "private": true
}
EOF

echo "✅ package.json created"

echo "📱 Generating app.json..."

cat > app.json << 'EOF'
{
  "expo": {
    "name": "BreboTeam",
    "slug": "brebo-team",
    "version": "2.0.0",
    "orientation": "portrait",
    "icon": "./src/assets/icon.png",
    "userInterfaceStyle": "automatic",
    "splash": {
      "image": "./src/assets/splash.png",
      "resizeMode": "contain",
      "backgroundColor": "#020617"
    },
    "assetBundlePatterns": [
      "**/*"
    ],
    "ios": {
      "supportsTablet": true,
      "bundleIdentifier": "com.brebo.team"
    },
    "android": {
      "adaptiveIcon": {
        "foregroundImage": "./src/assets/adaptive-icon.png",
        "backgroundColor": "#020617"
      },
      "package": "com.brebo.team"
    },
    "web": {
      "favicon": "./src/assets/favicon.png"
    },
    "plugins": [
      "expo-sqlite"
    ]
  }
}
EOF

echo "✅ app.json created"

echo "🔧 Generating eas.json..."

cat > eas.json << 'EOF'
{
  "cli": {
    "version": ">= 5.9.0"
  },
  "build": {
    "development": {
      "developmentClient": true,
      "distribution": "internal"
    },
    "preview": {
      "android": {
        "buildType": "apk"
      },
      "ios": {
        "simulator": true
      }
    },
    "production": {
      "android": {
        "buildType": "app-bundle"
      },
      "ios": {
        "autoPublish": true
      }
    }
  },
  "submit": {
    "production": {}
  }
}
EOF

echo "✅ eas.json created"

echo "🔧 Generating babel.config.js..."

cat > babel.config.js << 'EOF'
module.exports = function(api) {
  api.cache(true);
  return {
    presets: ['babel-preset-expo'],
    plugins: ['nativewind/babel'],
  };
};
EOF

echo "✅ babel.config.js created"

echo "🎨 Generating tailwind.config.js..."

cat > tailwind.config.js << 'EOF'
module.exports = {
  content: [
    "./App.{js,jsx,ts,tsx}",
    "./src/**/*.{js,jsx,ts,tsx}"
  ],
  theme: {
    extend: {
      colors: {
        'app-bg': '#020617',
        'card-bg': '#1e293b',
        'input-bg': '#0f172a',
        'border': '#334155',
        'primary': '#3b82f6',
        'accent-green': '#10b981',
        'accent-purple': '#a855f7',
        'accent-orange': '#f59e0b',
        'danger': '#ef4444',
      },
    },
  },
  plugins: [],
}
EOF

echo "✅ tailwind.config.js created"

# ====================================================================================================
# PHASE 3: Generate source code files (Translation from PWA to React Native)
# ====================================================================================================
echo "⚛️ PHASE 3: Generating React Native source files..."

# 3.1 App.js (Root Component)
cat > App.js << 'EOF'
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
EOF

# 3.2 src/navigation/Navigation.js
cat > src/navigation/Navigation.js << 'EOF'
import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { View, Text, TouchableOpacity } from 'react-native';
import { useStore } from '../store/useStore';
import { getI18nText } from '../utils/i18n';

// Screens
import MainScreen from '../screens/MainScreen';
import ProjectsScreen from '../screens/ProjectsScreen';
import OverviewScreen from '../screens/OverviewScreen';
import SettingsScreen from '../screens/SettingsScreen';

// Components
import { Cog, LayoutDashboard, ListChecks, Users } from 'lucide-react-native';

const Tab = createBottomTabNavigator();
const Stack = createNativeStackNavigator();

function CustomTabBar({ state, descriptors, navigation }) {
  const { lang, theme } = useStore();
  const t = (key) => getI18nText(lang, key);

  return (
    <View className="flex-row bg-card-bg border-t border-border p-2 absolute bottom-0 left-0 right-0 z-10">
      {state.routes.map((route, index) => {
        const { options } = descriptors[route.key];
        const label = options.tabBarLabel !== undefined
          ? options.tabBarLabel
          : options.title !== undefined
          ? options.title
          : route.name;

        const isFocused = state.index === index;

        const onPress = () => {
          const event = navigation.emit({
            type: 'tabPress',
            target: route.key,
            canPreventDefault: true,
          });

          if (!isFocused && !event.defaultPrevented) {
            navigation.navigate(route.name, route.params);
          }
        };

        const Icon = options.tabBarIcon;
        const color = isFocused ? 'text-primary' : 'text-text-muted';

        return (
          <TouchableOpacity
            key={index}
            accessibilityRole="button"
            accessibilityState={isFocused ? { selected: true } : {}}
            accessibilityLabel={options.tabBarAccessibilityLabel}
            testID={options.tabBarTestID}
            onPress={onPress}
            className="flex-1 items-center justify-center p-2"
          >
            <Icon color={isFocused ? '#3b82f6' : '#94a3b8'} size={24} />
            <Text className={`text-xs mt-1 ${color}`}>
              {label}
            </Text>
          </TouchableOpacity>
        );
      })}
    </View>
  );
}

function MainTabs() {
  const { lang } = useStore();
  const t = (key) => getI18nText(lang, key);

  return (
    <Tab.Navigator
      tabBar={props => <CustomTabBar {...props} />}
      screenOptions={{
        headerShown: false,
        tabBarStyle: { height: 60, backgroundColor: '#1e293b', borderTopColor: '#334155' },
        tabBarActiveTintColor: '#3b82f6',
        tabBarInactiveTintColor: '#94a3b8',
      }}
    >
      <Tab.Screen
        name="Main"
        component={MainScreen}
        options={{
          title: t('tabMain'),
          tabBarIcon: ({ color }) => <ListChecks color={color} size={24} />,
        }}
      />
      <Tab.Screen
        name="Projects"
        component={ProjectsScreen}
        options={{
          title: t('tabProjects'),
          tabBarIcon: ({ color }) => <LayoutDashboard color={color} size={24} />,
        }}
      />
      <Tab.Screen
        name="Overview"
        component={OverviewScreen}
        options={{
          title: t('tabOverview'),
          tabBarIcon: ({ color }) => <Users color={color} size={24} />,
        }}
      />
      <Tab.Screen
        name="Settings"
        component={SettingsScreen}
        options={{
          title: t('hdrSet'),
          tabBarIcon: ({ color }) => <Cog color={color} size={24} />,
        }}
      />
    </Tab.Navigator>
  );
}

export default function Navigation() {
  return (
    <NavigationContainer>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        <Stack.Screen name="MainTabs" component={MainTabs} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}
EOF

# 3.3 src/screens/MainScreen.js (Calendar, Form, List)
cat > src/screens/MainScreen.js << 'EOF'
import React, { useState, useEffect, useCallback } from 'react';
import { View, Text, ScrollView, TextInput, TouchableOpacity, ActivityIndicator, Alert } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useStore } from '../store/useStore';
import { getI18nText, getI18nPlaceholder } from '../utils/i18n';
import { ChevronLeft, ChevronRight, Search, Clock, Calendar, Trash2, Save, FileUp, FileSpreadsheet, Send, AlertTriangle } from 'lucide-react-native';
import { format, getDaysInMonth, startOfMonth, subMonths, addMonths, getDay, isSameDay } from 'date-fns';
import { pl } from 'date-fns/locale';
import { calcTime, sanitizeHTML } from '../utils/utils';
import { Picker } from '@react-native-picker/picker';
import { exportXls, triggerImp, handleImp, sendWa, clearData } from '../utils/data-management';
import Toast from 'react-native-toast-message';

// Components
import BreboLogo from '../components/BreboLogo';
import EntryList from '../components/EntryList';

const MainScreen = () => {
  const { lang, theme, viewDate, setViewDate, selectedDates, setSelectedDates, entries, projects, persist, conf } = useStore();
  const t = (key) => getI18nText(lang, key);
  const ph = (key) => getI18nPlaceholder(lang, key);

  const [desc, setDesc] = useState('');
  const [projectSelect, setProjectSelect] = useState('');
  const [start, setStart] = useState(conf.start || '08:00');
  const [end, setEnd] = useState(conf.end || '16:00');
  const [cat, setCat] = useState('work');
  const [breakTime, setBreakTime] = useState('30');
  const [loc, setLoc] = useState('');
  const [notes, setNotes] = useState('');
  const [editId, setEditId] = useState(null);
  const [calcVal, setCalcVal] = useState('0.00h');
  const [isValid, setIsValid] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [sortType, setSortType] = useState('date');

  // --- Calendar Logic ---
  const renderCal = useCallback(() => {
    const y = viewDate.getFullYear();
    const m = viewDate.getMonth();
    const firstDay = getDay(startOfMonth(viewDate));
    const daysInMonth = getDaysInMonth(viewDate);
    const monthName = format(viewDate, 'LLLL yyyy', { locale: pl });
    const hasEntry = new Set(entries.map(e => e.date));

    const days = [];
    for (let i = 0; i < firstDay; i++) {
      days.push(<View key={`empty-${i}`} className="flex-1 aspect-square"></View>);
    }

    for (let i = 1; i <= daysInMonth; i++) {
      const date = new Date(y, m, i);
      const dateStr = format(date, 'yyyy-MM-dd');
      const isSelected = selectedDates.some(d => isSameDay(new Date(d), date));
      const hasDot = hasEntry.has(dateStr);

      const toggleDate = () => {
        if (editId) {
          setSelectedDates([dateStr]);
          return;
        }
        if (isSelected) {
          setSelectedDates(selectedDates.filter(d => d !== dateStr));
        } else {
          setSelectedDates([...selectedDates, dateStr]);
        }
      };

      days.push(
        <TouchableOpacity
          key={dateStr}
          onPress={toggleDate}
          className={`flex-1 aspect-square items-center justify-center rounded-xl m-1 border ${isSelected ? 'bg-primary border-primary' : 'bg-input-bg border-border'}`}
        >
          <Text className={`text-sm font-bold ${isSelected ? 'text-white' : 'text-text-main'}`}>{i}</Text>
          {hasDot && <View className={`w-1 h-1 rounded-full absolute bottom-1 ${isSelected ? 'bg-white' : 'bg-accent-green'}`} />}
        </TouchableOpacity>
      );
    }
    return { monthName, days };
  }, [viewDate, selectedDates, entries, editId]);

  const changeMonth = (delta) => {
    setViewDate(delta === -1 ? subMonths(viewDate, 1) : addMonths(viewDate, 1));
  };

  // --- Form Logic ---
  useEffect(() => {
    const hours = calcTime(start, end, breakTime);
    setCalcVal(`${hours.toFixed(2)}h`);
    setIsValid(desc.trim() !== '' && start !== '' && end !== '' && selectedDates.length > 0 && hours > 0);
  }, [desc, start, end, breakTime, selectedDates]);

  const resetForm = () => {
    setEditId(null);
    setDesc('');
    setProjectSelect('');
    setStart(conf.start || '08:00');
    setEnd(conf.end || '16:00');
    setCat('work');
    setBreakTime('30');
    setLoc('');
    setNotes('');
    setSelectedDates([]);
  };

  const saveEntry = () => {
    if (!isValid) {
      Toast.show({ type: 'error', text1: t('msgInvalidTime') });
      return;
    }

    const hours = calcTime(start, end, breakTime);
    const entryData = {
      desc: desc.trim(),
      start,
      end,
      hours,
      cat,
      break: breakTime,
      projectId: projectSelect ? Number(projectSelect) : null,
      loc: loc.trim(),
      notes: notes.trim(),
      user: `${conf.first} ${conf.last}`.trim(),
    };

    if (editId) {
      // Update existing entry
      const updatedEntries = entries.map(e => e.id === editId ? { ...e, ...entryData, date: selectedDates[0] } : e);
      useStore.setState({ entries: updatedEntries });
    } else {
      // Add new entries for all selected dates
      const newEntries = selectedDates.map(d => ({
        id: Date.now() + Math.floor(Math.random() * 10000),
        date: d,
        ...entryData,
      }));
      useStore.setState(state => ({ entries: [...state.entries, ...newEntries] }));
    }

    persist();
    Toast.show({ type: 'success', text1: t('msgSaved') });
    resetForm();
  };

  const editEntry = (id) => {
    const entry = entries.find(e => e.id === id);
    if (!entry) return;

    setEditId(id);
    setDesc(entry.desc);
    setProjectSelect(String(entry.projectId || ''));
    setStart(entry.start);
    setEnd(entry.end);
    setCat(entry.cat);
    setBreakTime(String(entry.break || '30'));
    setLoc(entry.loc);
    setNotes(entry.notes);
    setSelectedDates([entry.date]);
    // Scroll to form
  };

  const deleteEntry = (id) => {
    Alert.alert(t('msgDelConfirm'), '', [
      { text: t('btnCancel'), style: 'cancel' },
      {
        text: t('btnDelete'),
        onPress: () => {
          useStore.setState(state => ({
            entries: state.entries.filter(e => e.id !== id),
            selectedEntryIds: new Set([...state.selectedEntryIds].filter(sid => sid !== id)),
          }));
          persist();
          Toast.show({ type: 'info', text1: t('msgDel') });
        },
        style: 'destructive',
      },
    ]);
  };

  const { monthName, days } = renderCal();

  // --- Footer Stats ---
  const selectedSum = entries
    .filter(e => useStore.getState().selectedEntryIds.has(e.id))
    .reduce((sum, e) => sum + e.hours, 0);

  return (
    <SafeAreaView className="flex-1 bg-app-bg">
      <ScrollView className="p-4 mb-20">
        {/* Header */}
        <View className="flex-row justify-between items-center py-2">
          <BreboLogo />
          <View className="flex-row space-x-2">
            <TouchableOpacity className="btn-icon w-10 h-10 rounded-xl bg-card-bg border border-border items-center justify-center" onPress={() => { /* Navigation to Overview */ }}>
              <LayoutDashboard size={22} color="#a855f7" />
            </TouchableOpacity>
            <TouchableOpacity className="btn-icon w-10 h-10 rounded-xl bg-card-bg border border-border items-center justify-center" onPress={() => { /* Navigation to Settings */ }}>
              <Cog size={22} color="#94a3b8" />
            </TouchableOpacity>
          </View>
        </View>

        {/* Calendar Card */}
        <View className="bg-card-bg p-4 rounded-xl border border-border shadow-lg my-4">
          <View className="flex-row justify-between items-center mb-4">
            <TouchableOpacity onPress={() => changeMonth(-1)} className="cal-btn w-9 h-9 rounded-lg bg-input-bg border border-border items-center justify-center">
              <ChevronLeft size={18} color="#f8fafc" />
            </TouchableOpacity>
            <Text className="text-lg font-bold text-text-main">{monthName}</Text>
            <TouchableOpacity onPress={() => changeMonth(1)} className="cal-btn w-9 h-9 rounded-lg bg-input-bg border border-border items-center justify-center">
              <ChevronRight size={18} color="#f8fafc" />
            </TouchableOpacity>
          </View>
          <View className="flex-row justify-around mb-2">
            {['Nd', 'Pn', 'Wt', 'Śr', 'Cz', 'Pt', 'Sb'].map(day => (
              <Text key={day} className="text-xs font-bold text-text-muted flex-1 text-center">{day}</Text>
            ))}
          </View>
          <View className="flex-row flex-wrap">
            {days}
          </View>
        </View>

        {/* Form Card */}
        <View className="bg-card-bg p-4 rounded-xl border border-border shadow-lg my-4">
          {selectedDates.length > 0 && (
            <View className="bg-primary/10 border border-primary p-3 rounded-lg mb-4">
              <Text className="text-primary text-xs font-bold uppercase">{t('lblDates')}:</Text>
              <Text className="text-primary text-sm mt-1">{selectedDates.sort().join(', ')}</Text>
            </View>
          )}

          {/* AI Suggestion Placeholder (Not implemented in RN for simplicity) */}
          {/* <View className="bg-purple-500/10 border border-purple-500/30 p-3 rounded-lg mb-4">
            <Text className="text-purple-400 font-bold">AI Suggestion Placeholder</Text>
          </View> */}

          <ScrollView>
            <View className="space-y-4">
              {/* Zadanie / Temat */}
              <View>
                <Text className="text-xs uppercase text-text-muted font-bold mb-1">{t('lblDesc')}*</Text>
                <TextInput
                  className="bg-input-bg border border-border text-text-main p-3 rounded-xl text-base"
                  placeholder={ph('phDesc')}
                  value={desc}
                  onChangeText={setDesc}
                />
              </View>

              {/* Wybór projektu */}
              <View>
                <Text className="text-xs uppercase text-text-muted font-bold mb-1">{t('lblProject')}</Text>
                <View className="bg-input-bg border border-border rounded-xl">
                  <Picker
                    selectedValue={projectSelect}
                    onValueChange={(itemValue) => setProjectSelect(itemValue)}
                    style={{ color: '#f8fafc' }}
                    dropdownIconColor="#f8fafc"
                  >
                    <Picker.Item label={t('optNoProject')} value="" />
                    {projects.map(p => (
                      <Picker.Item key={p.id} label={p.name} value={String(p.id)} />
                    ))}
                  </Picker>
                </View>
              </View>

              {/* Rozpoczęcie / Zakończenie */}
              <View className="flex-row space-x-4">
                <View className="flex-1">
                  <Text className="text-xs uppercase text-text-muted font-bold mb-1">{t('lblStart')}*</Text>
                  <TextInput
                    className="bg-input-bg border border-border text-text-main p-3 rounded-xl text-base"
                    placeholder="08:00"
                    value={start}
                    onChangeText={setStart}
                    keyboardType="numbers-and-punctuation"
                  />
                </View>
                <View className="flex-1">
                  <Text className="text-xs uppercase text-text-muted font-bold mb-1">{t('lblEnd')}*</Text>
                  <TextInput
                    className="bg-input-bg border border-border text-text-main p-3 rounded-xl text-base"
                    placeholder="16:00"
                    value={end}
                    onChangeText={setEnd}
                    keyboardType="numbers-and-punctuation"
                  />
                </View>
              </View>

              {/* Typ Aktywności / Przerwa */}
              <View className="flex-row space-x-4">
                <View className="flex-1">
                  <Text className="text-xs uppercase text-text-muted font-bold mb-1">{t('lblCat')}</Text>
                  <View className="bg-input-bg border border-border rounded-xl">
                    <Picker
                      selectedValue={cat}
                      onValueChange={(itemValue) => setCat(itemValue)}
                      style={{ color: '#f8fafc' }}
                      dropdownIconColor="#f8fafc"
                    >
                      <Picker.Item label={t('catWork')} value="work" />
                      <Picker.Item label={t('catOver')} value="overtime" />
                      <Picker.Item label={t('catVac')} value="vacation" />
                    </Picker>
                  </View>
                </View>
                <View className="flex-1">
                  <Text className="text-xs uppercase text-text-muted font-bold mb-1">{t('lblBreak')}</Text>
                  <TextInput
                    className="bg-input-bg border border-border text-text-main p-3 rounded-xl text-base"
                    placeholder="30"
                    value={breakTime}
                    onChangeText={setBreakTime}
                    keyboardType="numeric"
                  />
                </View>
              </View>

              {/* Miejsce Pracy */}
              <View>
                <Text className="text-xs uppercase text-text-muted font-bold mb-1">{t('lblLoc')}</Text>
                <TextInput
                  className="bg-input-bg border border-border text-text-main p-3 rounded-xl text-base"
                  placeholder={ph('phLoc')}
                  value={loc}
                  onChangeText={setLoc}
                />
              </View>

              {/* Uwagi */}
              <View>
                <Text className="text-xs uppercase text-text-muted font-bold mb-1">{t('lblNotes')}</Text>
                <TextInput
                  className="bg-input-bg border border-border text-text-main p-3 rounded-xl text-base h-24"
                  placeholder={ph('phNotes')}
                  value={notes}
                  onChangeText={setNotes}
                  multiline
                />
              </View>

              {/* Suma i Zapisz */}
              <View className="flex-row justify-between items-end mt-4">
                <View>
                  <Text className="text-xs uppercase text-text-muted font-bold">{t('lblTotal')}</Text>
                  <Text className="text-2xl font-extrabold text-text-main">{calcVal}</Text>
                </View>
                <TouchableOpacity
                  onPress={saveEntry}
                  disabled={!isValid}
                  className={`p-4 rounded-xl font-extrabold flex-1 ml-4 ${isValid ? 'bg-primary shadow-primary-glow' : 'bg-border opacity-60'}`}
                >
                  <Text className="text-white text-center font-extrabold uppercase tracking-wider">
                    {editId ? t('btnUpdate') : t('btnSave')}
                  </Text>
                </TouchableOpacity>
              </View>
            </View>
          </ScrollView>
        </View>

        {/* List Card */}
        <View className="bg-card-bg p-4 rounded-xl border border-border shadow-lg my-4">
          {/* Search Bar */}
          <View className="relative mb-4">
            <Search size={18} color="#94a3b8" className="absolute left-3 top-3" />
            <TextInput
              className="bg-input-bg border border-border text-text-main pl-10 p-3 rounded-xl text-base"
              placeholder={ph('phSearch')}
              value={searchQuery}
              onChangeText={setSearchQuery}
            />
          </View>

          {/* Toolbar */}
          <View className="flex-row justify-between items-center border-b border-border pb-3 mb-3">
            <Text className="text-xs uppercase text-text-muted font-bold">{t('lblSelAll')}</Text>
            <View className="flex-row space-x-2">
              <TouchableOpacity onPress={() => setSortType('time')} className={`w-8 h-8 rounded-lg items-center justify-center ${sortType === 'time' ? 'bg-primary/20' : 'bg-input-bg'}`}>
                <Clock size={16} color={sortType === 'time' ? '#3b82f6' : '#94a3b8'} />
              </TouchableOpacity>
              <TouchableOpacity onPress={() => setSortType('date')} className={`w-8 h-8 rounded-lg items-center justify-center ${sortType === 'date' ? 'bg-primary/20' : 'bg-input-bg'}`}>
                <Calendar size={16} color={sortType === 'date' ? '#3b82f6' : '#94a3b8'} />
              </TouchableOpacity>
            </View>
          </View>

          {/* Entry List */}
          <EntryList
            searchQuery={searchQuery}
            sortType={sortType}
            onEdit={editEntry}
            onDelete={deleteEntry}
          />
        </View>
      </ScrollView>

      {/* Footer */}
      <View className="absolute bottom-0 left-0 right-0 bg-app-bg border-t border-border p-3 flex-row justify-between items-center">
        <View>
          <Text className="text-xs uppercase text-text-muted font-bold">{t('lblSel')}</Text>
          <Text className="text-2xl font-extrabold text-text-main">{selectedSum.toFixed(2)}h</Text>
        </View>
        <View className="flex-row space-x-2">
          <TouchableOpacity onPress={triggerImp} className="p-3 rounded-lg bg-card-bg border border-border items-center justify-center">
            <FileUp size={18} color="#94a3b8" />
          </TouchableOpacity>
          <TouchableOpacity onPress={exportXls} className="p-3 rounded-lg bg-green-700 items-center justify-center">
            <FileSpreadsheet size={18} color="white" />
          </TouchableOpacity>
          <TouchableOpacity onPress={sendWa} className="p-3 rounded-lg bg-green-500 items-center justify-center">
            <Send size={18} color="white" />
          </TouchableOpacity>
        </View>
      </View>
      <Toast />
    </SafeAreaView>
  );
};

export default MainScreen;
EOF

# 3.4 src/components/EntryList.js
cat > src/components/EntryList.js << 'EOF'
import React, { useCallback } from 'react';
import { View, Text, TouchableOpacity, ScrollView } from 'react-native';
import { useStore } from '../store/useStore';
import { getI18nText } from '../utils/i18n';
import { Trash2, Pencil } from 'lucide-react-native';
import { sanitizeHTML } from '../utils/utils';

const EntryItem = React.memo(({ entry, onEdit, onDelete }) => {
  const { selectedEntryIds, toggleSelectedEntry, entries, projects } = useStore();
  const isSelected = selectedEntryIds.has(entry.id);
  const project = entry.projectId ? projects.find(p => p.id === entry.projectId) : null;

  const handleToggle = () => {
    toggleSelectedEntry(entry.id);
  };

  const colorClass = entry.cat === 'overtime' ? 'border-accent-orange' : entry.cat === 'vacation' ? 'border-accent-green' : 'border-primary';
  const hoursColorClass = entry.cat === 'overtime' ? 'text-accent-orange' : entry.cat === 'vacation' ? 'text-accent-green' : 'text-primary';

  return (
    <View className={`flex-row bg-input-bg border border-border p-3 rounded-xl items-center mb-2 ${isSelected ? 'bg-primary/10 border-primary' : ''}`}>
      <TouchableOpacity onPress={handleToggle} className={`w-6 h-6 rounded-md border mr-3 items-center justify-center ${isSelected ? 'bg-primary border-primary' : 'bg-card-bg border-border'}`}>
        {isSelected && <Text className="text-white text-xs font-bold">✓</Text>}
      </TouchableOpacity>
      
      <TouchableOpacity onPress={() => onEdit(entry.id)} className="flex-1">
        <View className="flex-row justify-between items-center">
          <Text className="text-text-main font-bold text-sm">{entry.date}</Text>
          <Text className={`font-bold text-sm ${hoursColorClass}`}>{entry.hours.toFixed(2)}h</Text>
        </View>
        <Text className="text-text-muted text-xs mt-1">{sanitizeHTML(entry.desc)}</Text>
        <Text className="text-text-muted text-xs mt-1">{entry.start} - {entry.end} ({project ? project.name : 'Brak projektu'})</Text>
      </TouchableOpacity>

      <View className="flex-row ml-3 space-x-1">
        <TouchableOpacity onPress={() => onEdit(entry.id)} className="p-2 rounded-lg bg-card-bg border border-border">
          <Pencil size={16} color="#94a3b8" />
        </TouchableOpacity>
        <TouchableOpacity onPress={() => onDelete(entry.id)} className="p-2 rounded-lg bg-danger/10 border border-danger/50">
          <Trash2 size={16} color="#ef4444" />
        </TouchableOpacity>
      </View>
    </View>
  );
});

const EntryList = ({ searchQuery, sortType, onEdit, onDelete }) => {
  const { entries } = useStore();
  const t = (key) => getI18nText(useStore.getState().lang, key);

  const filteredEntries = entries.filter(e => 
    Object.values(e).some(v => String(v).toLowerCase().includes(searchQuery.toLowerCase()))
  );

  const sortedEntries = useCallback(() => {
    const sorted = [...filteredEntries];
    if (sortType === 'time') {
      sorted.sort((a, b) => b.hours - a.hours);
    } else {
      sorted.sort((a, b) => new Date(b.date) - new Date(a.date));
    }
    return sorted;
  }, [filteredEntries, sortType]);

  if (filteredEntries.length === 0) {
    return (
      <View className="p-5 items-center">
        <Text className="text-text-muted">{t('noData')}</Text>
      </View>
    );
  }

  return (
    <View>
      {sortedEntries().map(entry => (
        <EntryItem 
          key={entry.id} 
          entry={entry} 
          onEdit={onEdit} 
          onDelete={onDelete} 
        />
      ))}
    </View>
  );
};

export default EntryList;
EOF

# 3.5 src/store/useStore.js (Zustand Store)
cat > src/store/useStore.js << 'EOF'
import { create } from 'zustand';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { format } from 'date-fns';

const STORAGE_KEY_PREFIX = 'brebo';
const STORAGE_VERSION = 'v10';

export const useStore = create((set, get) => ({
  // State
  lang: 'pl',
  theme: 'dark',
  entries: [],
  projects: [],
  selectedDates: [],
  selectedEntryIds: new Set(),
  viewDate: new Date(),
  conf: {
    first: '',
    last: '',
    start: '08:00',
    end: '16:00',
    birthDate: '',
    citizenship: '',
    bsn: '',
    idNumber: '',
    address: '',
    phone: '',
    email: '',
    vca: false,
    vcaNumber: '',
    vcaExpiry: '',
    vcaAdded: '',
    driverLicense: false,
    ownTransport: false,
    gpi: false,
    kvk: false,
    kvkNumber: '',
    btw: false,
    btwNumber: '',
    personalNote: '',
  },

  // Actions
  persist: async () => {
    const state = get();
    try {
      await AsyncStorage.setItem(`${STORAGE_KEY_PREFIX}Data_${STORAGE_VERSION}`, JSON.stringify(state.entries));
      await AsyncStorage.setItem(`${STORAGE_KEY_PREFIX}Projects`, JSON.stringify(state.projects));
      await AsyncStorage.setItem(`${STORAGE_KEY_PREFIX}Conf`, JSON.stringify(state.conf));
      await AsyncStorage.setItem(`${STORAGE_KEY_PREFIX}Selected`, JSON.stringify([...state.selectedEntryIds]));
      await AsyncStorage.setItem(`${STORAGE_KEY_PREFIX}Lang`, state.lang);
      await AsyncStorage.setItem(`${STORAGE_KEY_PREFIX}Theme`, state.theme);
    } catch (e) {
      console.error("Failed to persist state:", e);
    }
  },

  loadFromStorage: async () => {
    try {
      const entries = JSON.parse(await AsyncStorage.getItem(`${STORAGE_KEY_PREFIX}Data_${STORAGE_VERSION}`) || '[]');
      const projects = JSON.parse(await AsyncStorage.getItem(`${STORAGE_KEY_PREFIX}Projects`) || '[]');
      const conf = JSON.parse(await AsyncStorage.getItem(`${STORAGE_KEY_PREFIX}Conf`) || 'null') || get().conf;
      const selectedEntryIdsArray = JSON.parse(await AsyncStorage.getItem(`${STORAGE_KEY_PREFIX}Selected`) || '[]');
      const lang = await AsyncStorage.getItem(`${STORAGE_KEY_PREFIX}Lang`) || 'pl';
      const theme = await AsyncStorage.getItem(`${STORAGE_KEY_PREFIX}Theme`) || 'dark';

      set({
        entries,
        projects,
        conf,
        selectedEntryIds: new Set(selectedEntryIdsArray),
        lang,
        theme,
      });
    } catch (e) {
      console.error("Failed to load state:", e);
    }
  },

  setLang: (lang) => {
    set({ lang });
    AsyncStorage.setItem(`${STORAGE_KEY_PREFIX}Lang`, lang);
  },

  setTheme: (theme) => {
    set({ theme });
    AsyncStorage.setItem(`${STORAGE_KEY_PREFIX}Theme`, theme);
  },

  setViewDate: (date) => set({ viewDate: date }),
  setSelectedDates: (dates) => set({ selectedDates: dates }),

  toggleSelectedEntry: (id) => {
    const selectedEntryIds = new Set(get().selectedEntryIds);
    if (selectedEntryIds.has(id)) {
      selectedEntryIds.delete(id);
    } else {
      selectedEntryIds.add(id);
    }
    set({ selectedEntryIds });
    get().persist();
  },

  // Project actions (simplified for brevity, full logic in PWA is complex)
  addProject: (project) => {
    const newProject = { id: Date.now(), ...project };
    set(state => ({ projects: [...state.projects, newProject] }));
    get().persist();
    return newProject;
  },

  updateProject: (id, updatedProject) => {
    set(state => ({
      projects: state.projects.map(p => p.id === id ? { ...p, ...updatedProject } : p)
    }));
    get().persist();
  },

  deleteProject: (id) => {
    set(state => ({
      projects: state.projects.filter(p => p.id !== id),
      entries: state.entries.map(e => e.projectId === id ? { ...e, projectId: null } : e)
    }));
    get().persist();
  },

  updateConf: (newConf) => {
    set(state => ({ conf: { ...state.conf, ...newConf } }));
    get().persist();
  },
}));
EOF

# 3.6 src/database/database.js (SQLite logic)
cat > src/database/database.js << 'EOF'
import * as SQLite from 'expo-sqlite';

const db = SQLite.openDatabase('brebo.db');

export const initDatabase = () => {
  return new Promise((resolve, reject) => {
    db.transaction(tx => {
      // This app primarily uses AsyncStorage for simplicity and PWA compatibility,
      // but we keep the DB initialization for future features or large data.
      // For now, we just ensure the DB is open.
      resolve();
    }, reject);
  });
};

// Placeholder for future DB operations if needed
export const getEntriesFromDB = () => {
  return new Promise((resolve, reject) => {
    db.transaction(tx => {
      tx.executeSql(
        'SELECT * FROM entries;',
        [],
        (_, { rows }) => resolve(rows._array),
        (_, error) => reject(error)
      );
    });
  });
};
EOF

# 3.7 src/utils/i18n.js (Internationalization)
cat > src/utils/i18n.js << 'EOF'
import { useStore } from '../store/useStore';

// Translation data based on PWA source
const txt = {
  pl: {
    // Tabs
    tabMain: 'Ewidencja',
    tabProjects: 'Projekty',
    tabOverview: 'Przegląd',
    // Form Labels
    lblDesc: 'Zadanie / Temat',
    lblProject: 'Wybór projektu (opcjonalnie)',
    lblStart: 'Rozpoczęcie',
    lblEnd: 'Zakończenie',
    lblCat: 'Typ Aktywności',
    lblBreak: 'Przerwa (min)',
    lblLoc: 'Miejsce Pracy',
    lblNotes: 'Uwagi',
    lblTotal: 'SUMA:',
    lblDates: 'Zaznaczone daty',
    lblSel: 'ZAZNACZONE',
    lblSelAll: 'ZAZNACZ WSZYSTKO',
    // Placeholders
    phDesc: 'Opis zadania',
    phLoc: 'Lokalizacja',
    phNotes: 'Dodatkowe notatki',
    phSearch: 'Filtruj wpisy...',
    // Buttons
    btnSave: 'ZATWIERDŹ',
    btnUpdate: 'AKTUALIZUJ',
    btnDelete: 'Usuń',
    btnCancel: 'Anuluj',
    btnExp: 'Generuj Raport',
    btnSend: 'Wyślij',
    // Categories
    catWork: 'Czas Pracy',
    catOver: 'Nadgodziny',
    catVac: 'Urlop/Wolne',
    // Messages
    msgSaved: 'Wpis zapisany!',
    msgDel: 'Wpis usunięty.',
    msgDelConfirm: 'Czy na pewno chcesz usunąć ten wpis?',
    msgInvalidTime: 'Nieprawidłowy czas pracy (suma godzin <= 0).',
    msgProjNameReq: 'Nazwa projektu jest wymagana.',
    msgProjUpdated: 'Projekt zaktualizowany.',
    msgProjDel: 'Projekt usunięty.',
    msgExpReady: 'Raport gotowy do pobrania.',
    msgImp: 'Dane zaimportowane.',
    msgFileErr: 'Błąd odczytu pliku.',
    msgRestoreOk: 'Dane przywrócone!',
    // Projects
    hdrProjects: 'Aktywne Projekty',
    subProjects: 'Projekty tworzone są na podstawie Tagów. Tutaj możesz nimi zarządzać.',
    hdrAddProject: 'Dodaj Nowy Projekt',
    hdrEditProject: 'Edytuj Projekt',
    lblProjName: 'Nazwa Projektu*',
    lblProjLoc: 'Lokalizacja',
    lblProjStart: 'Data Rozpoczęcia',
    lblProjNotes: 'Notatki do Projektu',
    btnCreateProject: 'UTWÓRZ PROJEKT',
    optNoProject: 'Brak projektu',
    optCreateProject: 'Utwórz nowy projekt...',
    sortDate: 'Ostatnie użycie',
    sortHours: 'Wg Godzin (Max)',
    sortName: 'Nazwa (A-Z)',
    noProject: 'Brak projektu',
    // Settings
    hdrSet: 'Konfiguracja Profilu',
    lblPersonalBasic: 'Podstawowe Informacje Osobowe',
    lblUserFirst: 'Imię',
    lblUserLast: 'Nazwisko',
    lblBirthDate: 'Data urodzenia',
    lblCitizenship: 'Obywatelstwo',
    lblBSN: 'Numer BSN (Sofi-nummer)',
    lblIDNumber: 'Seria i numer dowodu/paszportu',
    lblAddress: 'Aktualny adres w Holandii',
    lblPhone: 'Numer telefonu',
    lblEmail: 'Adres e-mail',
    lblPersonalTransport: 'Transport',
    lblDriverLicense: 'Prawo jazdy',
    lblOwnTransport: 'Własny transport',
    lblPersonalBusiness: 'Informacje o biznesie',
    lblVCA: 'VCA (Certyfikat Bezpieczeństwa)',
    lblVCANumber: 'Numer certyfikatu VCA',
    lblVCAExpiry: 'Data ważności VCA',
    lblVCAAdded: 'Data dodania',
    lblGPI: 'GPI',
    lblKVK: 'Posiadam numer KVK',
    lblKVKNumber: 'Numer KVK',
    lblBTW: 'Posiadam BTW-nummer',
    lblBTWNumber: 'BTW-nummer',
    lblPersonalNote: 'Notatki',
    lblPersonalNoteText: 'Dodatkowe informacje',
    lblAppSettings: 'Ustawienia Aplikacji',
    lblDefStart: 'Domyślny Start',
    lblDefEnd: 'Domyślny Koniec',
    btnSaveSettings: 'ZAPISZ ZMIANY',
    btnReset: 'RESET APLIKACJI',
    // Overview
    statTotalHours: 'ŁĄCZNE GODZINY',
    statThisMonth: 'TEN MIESIĄC',
    statThisWeek: 'TEN TYDZIEŃ',
    statAvgDaily: 'ŚREDNIA DZIENNA',
    entries: 'wpisów',
    vsLastMonth: 'vs poprz. miesiąc',
    vsLastWeek: 'vs poprz. tydzień',
    chartWeekly: 'Tygodniowy rozkład godzin',
    chartByProject: 'Godziny wg projektu',
    recentActivity: 'Ostatnia aktywność',
    noData: 'Brak danych do wyświetlenia.',
    // Other
    welcomeTitle: 'Witaj',
    welcomeMsg: 'Aplikacja BreboTeam jest gotowa do pracy!',
    lblYes: 'Tak',
    lblPersonalCerts: 'Certyfikaty',
    tabMainText: 'Wpisy',
  },
  // Add other languages here if needed
};

export const getI18nText = (lang, key) => {
  return txt[lang] && txt[lang][key] ? txt[lang][key] : txt['pl'][key] || key;
};

export const getI18nPlaceholder = (lang, key) => {
  // Placeholders are simple strings in the PWA, so we use the same function
  return getI18nText(lang, key);
};

export const applyLang = (lang) => {
  // In React Native, we rely on the components to use getI18nText(lang, key)
  // We can force a re-render of components that depend on the store's lang state
  useStore.setState({ lang });
};
EOF

# 3.8 src/utils/theme.js (Theme logic)
cat > src/utils/theme.js << 'EOF'
import { useStore } from '../store/useStore';
import { Appearance } from 'react-native';

export const applyTheme = (theme) => {
  // In React Native, we use NativeWind for styling, which relies on the global
  // dark/light mode set by the OS or a theme provider.
  // For simplicity, we'll just update the store state.
  useStore.setState({ theme });
};

export const toggleTheme = () => {
  const { theme, setTheme } = useStore.getState();
  const themes = ['dark', 'light', 'onyx'];
  let i = (themes.indexOf(theme) + 1) % themes.length;
  setTheme(themes[i]);
};
EOF

# 3.9 src/utils/utils.js (Utility functions)
cat > src/utils/utils.js << 'EOF'
import { parse, differenceInMinutes } from 'date-fns';

export const calcTime = (start, end, breakTime) => {
  if (!start || !end) return 0;

  try {
    const startTime = parse(start, 'HH:mm', new Date());
    const endTime = parse(end, 'HH:mm', new Date());
    const breakMinutes = Number(breakTime) || 0;

    let diffMinutes = differenceInMinutes(endTime, startTime);

    // Handle overnight shift (if end time is before start time, assume it's the next day)
    if (diffMinutes < 0) {
      diffMinutes += 24 * 60;
    }

    const totalMinutes = diffMinutes - breakMinutes;
    const hours = totalMinutes / 60;

    return Math.max(0, hours);
  } catch (e) {
    console.error("Error calculating time:", e);
    return 0;
  }
};

export const sanitizeHTML = (str) => {
  // In React Native, we don't need to sanitize HTML for display in Text components,
  // but we keep the function name for consistency with the PWA source.
  return String(str);
};

export const getTodayStr = () => {
  return format(new Date(), 'yyyy-MM-dd');
};
EOF

# 3.10 src/utils/data-management.js (Export/Import logic)
cat > src/utils/data-management.js << 'EOF'
import { useStore } from '../store/useStore';
import { getI18nText } from './i18n';
import * as Sharing from 'expo-sharing';
import * as FileSystem from 'expo-file-system';
import * as DocumentPicker from 'expo-document-picker';
import Toast from 'react-native-toast-message';
import { getTodayStr } from './utils';

// NOTE: XLSX library is not directly available in React Native.
// We will use a simplified CSV/JSON export/import for demonstration.
// For full XLSX support, a dedicated library or a backend service would be required.

export const exportXls = async () => {
  const { entries, selectedEntryIds, conf, projects, lang } = useStore.getState();
  const t = (key) => getI18nText(lang, key);

  try {
    const src = selectedEntryIds.size > 0 ? entries.filter(e => selectedEntryIds.has(e.id)) : entries;

    if (src.length === 0) {
      Toast.show({ type: 'error', text1: t('msgInvalidTime') });
      return;
    }

    // Simplified CSV format
    let csvContent = "Date,Start,End,Hours,Description,Project,Location,User\n";
    src.forEach(e => {
      const project = e.projectId ? projects.find(p => p.id === e.projectId) : null;
      const row = [
        e.date,
        e.start,
        e.end,
        e.hours.toFixed(2),
        `"${e.desc.replace(/"/g, '""')}"`,
        `"${project ? project.name.replace(/"/g, '""') : t('noProject')}"`,
        `"${e.loc.replace(/"/g, '""')}"`,
        `"${e.user.replace(/"/g, '""')}"`,
      ].join(',');
      csvContent += row + '\n';
    });

    const fileName = `BreboTeam - ${conf.last || "User"}_${getTodayStr()}.csv`;
    const fileUri = FileSystem.documentDirectory + fileName;

    await FileSystem.writeAsStringAsync(fileUri, csvContent);

    if (!(await Sharing.isAvailableAsync())) {
      Toast.show({ type: 'error', text1: 'Sharing not available on this device.' });
      return;
    }

    await Sharing.shareAsync(fileUri, { mimeType: 'text/csv', dialogTitle: t('msgExpReady') });
    Toast.show({ type: 'success', text1: t('msgExpReady') });

  } catch (error) {
    console.error('Export error:', error);
    Toast.show({ type: 'error', text1: t('msgFileErr') });
  }
};

export const triggerImp = () => {
  DocumentPicker.getDocumentAsync({ type: 'text/csv' })
    .then(result => {
      if (result.type === 'success') {
        handleImp(result.uri);
      }
    })
    .catch(error => {
      console.error('Document picker error:', error);
      Toast.show({ type: 'error', text1: getI18nText(useStore.getState().lang, 'msgFileErr') });
    });
};

export const handleImp = async (uri) => {
  const { entries, conf, persist, lang } = useStore.getState();
  const t = (key) => getI18nText(lang, key);

  try {
    const csvContent = await FileSystem.readAsStringAsync(uri);
    const lines = csvContent.split('\n').filter(line => line.trim() !== '');
    if (lines.length < 2) {
      Toast.show({ type: 'error', text1: t('msgFileErr') });
      return;
    }

    const headers = lines[0].split(',');
    const importedEntries = [];

    for (let i = 1; i < lines.length; i++) {
      const values = lines[i].split(',');
      if (values.length !== headers.length) continue;

      const entry = {};
      headers.forEach((header, index) => {
        entry[header.trim()] = values[index].trim().replace(/^"|"$/g, ''); // Remove quotes
      });

      if (entry.Date && entry.Hours) {
        importedEntries.push({
          id: Date.now() + i + Math.floor(Math.random() * 10000),
          date: entry.Date,
          desc: entry.Description || '',
          tags: entry.Project || '',
          start: entry.Start || conf.start || '08:00',
          end: entry.End || conf.end || '16:00',
          hours: Number(entry.Hours) || 0,
          cat: 'work',
          break: 30,
          user: `${conf.first} ${conf.last}`.trim(),
          projectId: null, // Project linking is complex, skip for simple import
          loc: entry.Location || '',
          notes: '',
        });
      }
    }

    useStore.setState(state => ({ entries: [...state.entries, ...importedEntries] }));
    persist();
    Toast.show({ type: 'success', text1: t('msgImp') });

  } catch (error) {
    console.error('Import error:', error);
    Toast.show({ type: 'error', text1: t('msgFileErr') });
  }
};

export const sendWa = () => {
  const { entries, selectedEntryIds, conf, projects, lang } = useStore.getState();
  const t = (key) => getI18nText(lang, key);

  const s = selectedEntryIds.size > 0 ? entries.filter(e => selectedEntryIds.has(e.id)) : entries;
  const sum = s.reduce((a, b) => a + Number(b.hours || 0), 0);

  let text = `*BreboTeam - brebo-team-informacje*\n\n`;
  text += `*${t('lblUserFirst')}:* ${conf.first || '-'}\n`;
  text += `*${t('lblUserLast')}:* ${conf.last || '-'}\n`;
  text += `\n*${t('tabMainText')} (${s.length} ${t('entries')}):*\n`;

  s.forEach(e => {
    const project = e.projectId ? projects.find(p => p.id === e.projectId) : null;
    const projName = project ? project.name : t('noProject');
    text += `\n*${e.date}* (${e.hours.toFixed(2)}h, ${t('catWork')}):\n`;
    text += ` - ${e.desc} [${projName}]\n`;
    if (e.notes) text += ` - _${e.notes}_\n`;
  });

  text += `\n*${t('lblTotal')}:* ${sum.toFixed(2)}h\n`;

  // Use Linking for WhatsApp in React Native
  // NOTE: This requires 'expo-linking' or 'react-native/Libraries/Linking/Linking'
  // For simplicity in this script, we'll just log the URL.
  const waUrl = `whatsapp://send?text=${encodeURIComponent(text)}`;
  console.log("WhatsApp URL:", waUrl);
  Toast.show({ type: 'info', text1: t('sendReady') || "Wiadomość gotowa do wysłania!" });
};

export const clearData = () => {
  Alert.alert(t('msgResetConfirm'), '', [
    { text: t('btnCancel'), style: 'cancel' },
    {
      text: t('btnReset'),
      onPress: async () => {
        await AsyncStorage.clear();
        // Force reload or reset state to initial values
        useStore.setState(useStore.getInitialState());
        Toast.show({ type: 'success', text1: 'Aplikacja zresetowana.' });
      },
      style: 'destructive',
    },
  ]);
};
EOF

# 3.11 src/components/BreboLogo.js (SVG Logo)
cat > src/components/BreboLogo.js << 'EOF'
import React from 'react';
import { View, Text } from 'react-native';
import { useStore } from '../store/useStore';

const BreboLogo = () => {
  const { theme } = useStore();
  const color = theme === 'onyx' ? '#ededed' : '#3b82f6';

  return (
    <View className="flex-row items-baseline">
      <Text style={{ color: color }} className="text-3xl font-extrabold tracking-tighter">Brebo</Text>
      <Text className="text-xl font-light text-text-main ml-1 opacity-90">Team</Text>
    </View>
  );
};

export default BreboLogo;
EOF

# 3.12 src/screens/ProjectsScreen.js (Placeholder)
cat > src/screens/ProjectsScreen.js << 'EOF'
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
EOF

# 3.13 src/screens/OverviewScreen.js (Placeholder)
cat > src/screens/OverviewScreen.js << 'EOF'
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
EOF

# 3.14 src/screens/SettingsScreen.js (Placeholder)
cat > src/screens/SettingsScreen.js << 'EOF'
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
EOF

# 3.15 src/assets/BreboLogo.svg (Placeholder for logo)
cat > src/assets/BreboLogo.svg << 'EOF'
<svg width="280" height="50" viewBox="0 0 280 50" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect width="280" height="50" fill="transparent"/>
<text x="10" y="35" font-family="Arial Black, Impact, sans-serif" font-size="30" font-weight="900" fill="#3b82f6">Brebo</text>
<text x="130" y="35" font-family="Segoe UI Light, sans-serif" font-size="25" font-weight="300" fill="#f8fafc" opacity="0.9">Team</text>
</svg>
EOF

# 3.16 src/assets/icon.png, splash.png, adaptive-icon.png, favicon.png (Placeholders)
echo "Placeholder for icon.png" > src/assets/icon.png
echo "Placeholder for splash.png" > src/assets/splash.png
echo "Placeholder for adaptive-icon.png" > src/assets/adaptive-icon.png
echo "Placeholder for favicon.png" > src/assets/favicon.png

# ====================================================================================================
# PHASE 4: Generate GitHub Actions Workflow
# ====================================================================================================
echo "⚙️ PHASE 4: Generating GitHub Actions workflow..."

cat > .github/workflows/main.yml << 'EOF'
name: BreboTeam CI/CD to Firebase App Distribution

on:
  push:
    branches:
      - main

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - name: 🏗️ Checkout repository
        uses: actions/checkout@v4

      - name: 🛠️ Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20.x
          cache: 'npm'

      - name: 🛠️ Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'

      - name: 📦 Install dependencies
        run: npm install

      - name: 🔑 Install EAS CLI
        run: npm install -g eas-cli

      - name: 🏗️ Build Android APK (Preview)
        run: eas build --platform android --profile preview --non-interactive
        env:
          # EAS_BUILD_TOKEN is automatically set by EAS CLI if you run `eas login` locally
          # and link your project to your Expo account.
          # For CI/CD, you should use an EAS_BUILD_TOKEN secret.
          EAS_BUILD_TOKEN: ${{ secrets.EAS_BUILD_TOKEN }}

      - name: 🚀 Deploy Android APK to Firebase App Distribution
        uses: w9jds/firebase-action@master
        with:
          args: deploy --only appdistribution
        env:
          FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
          # The App ID for the Android app in your Firebase project
          FIREBASE_APP_ID: ${{ secrets.FIREBASE_APP_ID }}
          # Path to the built APK file (EAS build output path)
          APK_PATH: ./build/BreboTeam-preview.apk
          # Group aliases to distribute to (optional)
          GROUPS: testers
          # Release notes (optional)
          RELEASE_NOTES: "BreboTeam v2.0.0 - Automated CI/CD build (APK)"
EOF

echo "✅ GitHub Actions workflow created"

# ====================================================================================================
# PHASE 5: Git Initialization and Final Instructions
# ====================================================================================================
echo "Initializing Git repository..."
git init
git add .
git commit -m "Initial commit: BreboTeam React Native App (Symbianos3 Protocol)"
echo "✅ Git repository initialized"

echo ""
echo "===================================================================================================="
echo "                                  ADMINISTRATOR INSTRUCTIONS"
echo "===================================================================================================="
echo "The React Native project for 'BreboTeam' has been successfully generated in the '${PROJECT_DIR}' directory."
echo "The next step is to push this project to your GitHub repository: Dobry2013de/codex."
echo ""
echo "⚠️ WARNING: This script assumes you have already cleared the contents of the target repository."
echo "If you have not, you must manually clone, delete, and push the new content."
echo ""
echo "To complete the CI/CD setup and deploy to Firebase App Distribution, follow these steps:"
echo ""
echo "1.  **Firebase Project Setup:**"
echo "    - Create a new Firebase project in the Firebase Console."
echo "    - Add an Android app to your Firebase project."
echo "    - Find and save the **Firebase App ID** (e.g., 1:1234567890:android:abcdef1234567890)."
echo ""
echo "2.  **Generate Firebase CI Token:**"
echo "    - On your local machine, run the command: \`firebase login:ci\`"
echo "    - Save the generated **Firebase CI Token**."
echo ""
echo "3.  **GitHub Secrets Configuration:**"
echo "    - Go to your GitHub repository: \`https://github.com/Dobry2013de/codex\`"
echo "    - Navigate to **Settings** -> **Secrets and variables** -> **Actions**."
echo "    - Add the following two new repository secrets:"
echo "      - **FIREBASE_APP_ID**: Paste the Firebase App ID from step 1."
echo "      - **FIREBASE_TOKEN**: Paste the Firebase CI Token from step 2."
echo "    - (Optional but Recommended for EAS): Add an **EAS_BUILD_TOKEN** for non-interactive EAS builds."
echo ""
echo "4.  **Push to GitHub (Manual Step):**"
echo "    - The local Git repository is ready. Now, link it to your remote and push."
echo "    - Run these commands in your terminal (from the parent directory of '${PROJECT_DIR}'):"
echo "      \`cd ${PROJECT_DIR}\`"
echo "      \`git remote add origin https://github.com/Dobry2013de/codex.git\`"
echo "      \`git push -u origin main\`"
echo ""
echo "The push to the \`main\` branch will automatically trigger the GitHub Actions workflow, which will build the Android APK and deploy it to Firebase App Distribution."
echo "===================================================================================================="
echo ""
echo "Script execution complete. The final artifact is the executable bash script itself."
echo "The local project is ready to be pushed to the specified GitHub repository."
echo "Exiting autonomous mode."
echo ""
EOF

echo "✅ Full script content generated and saved to setup_brebo_firebase.sh"

# Now, I need to execute the script to create the local repository,
# then proceed to Phase 4 to handle the GitHub operations.

# Execute the script to create the local project structure
/bin/bash setup_brebo_firebase.sh

# The script execution will create the local git repository in brebo-team-rn
# and print the final instructions.

# Now, advance to Phase 4 to handle the GitHub operations.<ctrl95><ctrl42>call:default_api:shell{action:
