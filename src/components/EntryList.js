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
