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
    } else {
      router.push('/auth');
    }
  };

  const handleLogout = async () => {
    await supabase.auth.signOut();
    router.push('/');
  };

  const handleCategoryClick = (categoryId: string, categoryName: string) => {
    router.push(`/sellers?category=${categoryId}&name=${categoryName}`);
  };

  const handleLocationChange = async (newCity: string) => {
    if (user) {
      await supabase
        .from('users')
        .update({ city: newCity, location: newCity })
        .eq('id', user.id);
      setUserCity(newCity);
    }
  };

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="liquid-glass sticky top-0 z-50">
        <div className="container mx-auto px-4 py-4 flex justify-between items-center">
          <button
            onClick={() => router.push('/')}
            className="flex items-center gap-2 text-white hover:text-white/80 transition"
          >
            <Home className="w-6 h-6" />
            <span className="font-semibold">Inicio</span>
          </button>
          <div className="flex items-center gap-4">
            <div className="flex items-center gap-2 text-white">
              <MapPin className="w-4 h-4" />
              <select
                value={userCity}
                onChange={(e) => handleLocationChange(e.target.value)}
                className="bg-transparent border-none focus:outline-none text-white"
              >
                <option value="">Seleccionar ciudad</option>
                <option value="Bogotá">Bogotá</option>
                <option value="Medellín">Medellín</option>
                <option value="Cali">Cali</option>
                <option value="Barranquilla">Barranquilla</option>
                <option value="Cartagena">Cartagena</option>
                <option value="Bucaramanga">Bucaramanga</option>
                <option value="Pereira">Pereira</option>
                <option value="Manizales">Manizales</option>
              </select>
            </div>
            <button
              onClick={handleLogout}
              className="glass px-4 py-2 rounded-lg text-white hover:bg-white/20 transition"
            >
              <LogOut className="w-4 h-4" />
            </button>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-12">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-white mb-4">
            Categorías de Servicios
          </h1>
          <p className="text-xl text-white/70">
            {userCity ? `Mostrando servicios en ${userCity}` : 'Selecciona tu ciudad para ver servicios locales'}
          </p>
        </div>

        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {categories.map((category) => (
            <button
              key={category.id}
              onClick={() => handleCategoryClick(category.id, category.name)}
              className="liquid-glass rounded-2xl p-6 text-center hover:scale-105 transition-transform cursor-pointer"
            >
              <div className="text-5xl mb-4">{category.icon}</div>
              <h3 className="text-lg font-semibold text-white mb-2">
                {category.name}
              </h3>
              <p className="text-sm text-white/60">
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
