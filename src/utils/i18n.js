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
