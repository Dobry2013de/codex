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
