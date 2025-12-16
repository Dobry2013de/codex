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
