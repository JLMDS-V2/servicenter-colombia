'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { supabase } from '@/lib/supabase';
import { categories } from '@/lib/data';
import { User } from '@/types';
import { Home, MapPin, LogOut } from 'lucide-react';

export default function CategoriesPage() {
  const router = useRouter();
  const [user, setUser] = useState<User | null>(null);
  const [userCity, setUserCity] = useState('');

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
    if (user) {
      await supabase
        .from('users')
        .update({ city: newCity, location: newCity })
        .eq('id', user.id);
    }
  };

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="liquid-glass sticky top-0 z-50">
        <div className="container mx-auto px-4 py-3 sm:py-4 flex justify-between items-center flex-wrap gap-2">
          <button
            onClick={() => router.push('/')}
            className="flex items-center gap-2 text-white hover:text-white/80 transition"
          >
            <Home className="w-5 h-5 sm:w-6 sm:h-6" />
            <span className="font-semibold text-sm sm:text-base">ServiCenter</span>
          </button>
          <div className="flex items-center gap-2 sm:gap-4">
            <div className="flex items-center gap-1 sm:gap-2 text-white">
              <MapPin className="w-4 h-4" />
              <select
                value={userCity}
                onChange={(e) => handleLocationChange(e.target.value)}
                className="bg-transparent border-none focus:outline-none text-white text-xs sm:text-sm"
              >
                <option value="" className="bg-gray-800">Todas las ciudades</option>
                <option value="Bogotá" className="bg-gray-800">Bogotá</option>
                <option value="Medellín" className="bg-gray-800">Medellín</option>
                <option value="Cali" className="bg-gray-800">Cali</option>
                <option value="Barranquilla" className="bg-gray-800">Barranquilla</option>
                <option value="Cartagena" className="bg-gray-800">Cartagena</option>
                <option value="Bucaramanga" className="bg-gray-800">Bucaramanga</option>
                <option value="Pereira" className="bg-gray-800">Pereira</option>
                <option value="Manizales" className="bg-gray-800">Manizales</option>
                <option value="Cúcuta" className="bg-gray-800">Cúcuta</option>
              </select>
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
