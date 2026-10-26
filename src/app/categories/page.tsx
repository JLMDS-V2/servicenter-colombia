'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { supabase } from '@/lib/supabase';
import { categories, citiesColombia } from '@/lib/data';
import { User } from '@/types';
import { Home, MapPin, LogOut, Search } from 'lucide-react';

export default function CategoriesPage() {
  const router = useRouter();
  const [user, setUser] = useState<User | null>(null);
  const [userCity, setUserCity] = useState('');
  const [searchQuery, setSearchQuery] = useState('');
  const [showCityDropdown, setShowCityDropdown] = useState(false);

  useEffect(() => {
    checkUser();
  }, []);

  const checkUser = async () => {
    const { data: { session } } = await supabase.auth.getSession();
    if (session?.user) {
      const { data: userData } = await supabase
        .from('users')
        .select('*')
        .eq('id', session.user.id)
        .single();
      setUser(userData);
      setUserCity(userData?.city || '');
    }
  };

  const handleLogout = async () => {
    await supabase.auth.signOut();
    router.push('/');
  };

  const handleCategoryClick = (categoryId: string, categoryName: string) => {
    router.push(`/sellers?category=${categoryId}&name=${categoryName}&city=${userCity}`);
  };

  const handleLocationChange = async (newCity: string) => {
    setUserCity(newCity);
    setShowCityDropdown(false);
    if (user) {
      await supabase
        .from('users')
        .update({ city: newCity, location: newCity })
        .eq('id', user.id);
    }
  };

  const filteredCities = citiesColombia.filter(city =>
    city.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    city.department.toLowerCase().includes(searchQuery.toLowerCase())
  ).slice(0, 30);

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="liquid-glass sticky top-0 z-[100]">
        <div className="container mx-auto px-4 py-3 sm:py-4 flex justify-between items-center flex-wrap gap-2">
          <button
            onClick={() => router.push('/')}
            className="flex items-center gap-2 text-white hover:text-white/80 transition"
          >
            <Home className="w-5 h-5 sm:w-6 sm:h-6" />
            <span className="font-semibold text-sm sm:text-base">ServiCenter</span>
          </button>
          <div className="flex items-center gap-2 sm:gap-4 relative">
            <div className="flex items-center gap-1 sm:gap-2 text-white">
              <MapPin className="w-4 h-4" />
              <div className="relative">
                <input
                  type="text"
                  placeholder="Buscar ciudad..."
                  value={userCity}
                  onChange={(e) => {
                    setSearchQuery(e.target.value);
                    setUserCity(e.target.value);
                    setShowCityDropdown(true);
                  }}
                  onFocus={() => setShowCityDropdown(true)}
                  className="bg-transparent border-none focus:outline-none text-white text-xs sm:text-sm w-32 sm:w-40 md:w-48 placeholder-white/50"
                />
                {showCityDropdown && searchQuery && (
                  <div className="absolute top-full left-0 mt-2 w-64 sm:w-80 max-h-96 overflow-y-auto glass rounded-xl z-[9999]">
                    {filteredCities.length === 0 ? (
                      <div className="p-4 text-white/60 text-sm">No se encontraron ciudades</div>
                    ) : (
                      filteredCities.map((city) => (
                        <button
                          key={city.id}
                          onClick={() => handleLocationChange(city.name)}
                          className="w-full text-left px-4 py-2 text-white hover:bg-white/20 transition text-sm border-b border-white/10 last:border-0"
                        >
                          <div className="font-medium">{city.name}</div>
                          <div className="text-white/60 text-xs">{city.department}</div>
                        </button>
                      ))
                    )}
                  </div>
                )}
              </div>
            </div>
            {user ? (
              <button
                onClick={handleLogout}
                className="glass px-3 py-1.5 sm:px-4 sm:py-2 rounded-lg text-white hover:bg-white/20 transition"
              >
                <LogOut className="w-4 h-4" />
              </button>
            ) : (
              <button
                onClick={() => router.push('/auth')}
                className="glass px-3 py-1.5 sm:px-4 sm:py-2 rounded-lg text-white hover:bg-white/20 transition text-xs sm:text-sm"
              >
                Iniciar Sesión
              </button>
            )}
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8 sm:py-12">
        <div className="text-center mb-8 sm:mb-12">
          <h1 className="text-3xl sm:text-4xl font-bold text-white mb-3 sm:mb-4">
            Categorías de Servicios
          </h1>
          <p className="text-lg sm:text-xl text-white/70 px-2">
            {userCity ? `Mostrando servicios en ${userCity}` : 'Explora todas las categorías - Filtra por ciudad'}
          </p>
        </div>

        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3 sm:gap-6">
          {categories.map((category) => (
            <button
              key={category.id}
              onClick={() => handleCategoryClick(category.id, category.name)}
              className="liquid-glass rounded-2xl p-4 sm:p-6 text-center hover:scale-105 transition-transform cursor-pointer"
            >
              <div className="text-4xl sm:text-5xl mb-3 sm:mb-4">{category.icon}</div>
              <h3 className="text-base sm:text-lg font-semibold text-white mb-1 sm:mb-2">
                {category.name}
              </h3>
              <p className="text-xs sm:text-sm text-white/60">
                {category.description}
              </p>
            </button>
          ))}
        </div>
      </main>

      {/* Ad Space */}
      <section className="container mx-auto px-4 py-8">
        <div className="glass rounded-xl p-8 text-center">
          <p className="text-white/60 text-sm">Espacio para anuncios</p>
        </div>
      </section>
    </div>
  );
}
