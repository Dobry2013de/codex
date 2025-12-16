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
