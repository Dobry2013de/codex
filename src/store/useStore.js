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
