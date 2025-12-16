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
