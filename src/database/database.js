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
