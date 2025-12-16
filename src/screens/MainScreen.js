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
