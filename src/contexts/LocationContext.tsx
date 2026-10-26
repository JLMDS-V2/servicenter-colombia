'use client';

import { createContext, useContext, useState, useEffect, ReactNode } from 'react';

interface LocationContextType {
  userCity: string;
  setUserCity: (city: string) => void;
  clearCity: () => void;
}

const LocationContext = createContext<LocationContextType | undefined>(undefined);

export function LocationProvider({ children }: { children: ReactNode }) {
  const [userCity, setUserCityState] = useState('');

  useEffect(() => {
    // Load saved city from localStorage on mount
    const savedCity = localStorage.getItem('selectedCity');
    if (savedCity) {
      setUserCityState(savedCity);
    }
  }, []);

  const setUserCity = (city: string) => {
    setUserCityState(city);
    localStorage.setItem('selectedCity', city);
  };

  const clearCity = () => {
    setUserCityState('');
    localStorage.removeItem('selectedCity');
  };

  return (
    <LocationContext.Provider value={{ userCity, setUserCity, clearCity }}>
      {children}
    </LocationContext.Provider>
  );
}

export function useLocation() {
  const context = useContext(LocationContext);
  if (context === undefined) {
    throw new Error('useLocation must be used within a LocationProvider');
  }
  return context;
}
