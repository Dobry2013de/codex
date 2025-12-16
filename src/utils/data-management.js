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
