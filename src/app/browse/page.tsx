'use client';

import { useState, useEffect, Suspense } from 'react';
import { useRouter } from 'next/navigation';
import { supabase } from '@/lib/supabase';
import { Seller } from '@/types';
import { categories, citiesColombia } from '@/lib/data';
import { Star, MessageCircle, Phone, CheckCircle, Shield, MapPin, Filter, Home } from 'lucide-react';

function BrowseContent() {
  const router = useRouter();
  const [sellers, setSellers] = useState<Seller[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedCity, setSelectedCity] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('');
  const [user, setUser] = useState<any>(null);

  useEffect(() => {
    checkUser();
    fetchSellers();
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
    }
  };

  const fetchSellers = async () => {
    setLoading(true);
    try {
      let query = supabase
        .from('users')
        .select('*')
        .eq('role', 'seller');

      const { data, error } = await query;
      if (error) throw error;
      setSellers(data || []);
    } catch (err) {
      console.error('Error fetching sellers:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleContact = (sellerId: string) => {
    if (!user) {
      router.push('/auth?redirect=/browse&message=' + encodeURIComponent('Iniciar sesión para continuar con el contacto'));
      return;
    }
    router.push(`/chat?seller=${sellerId}`);
  };

  const openWhatsApp = (phone: string) => {
    if (!user) {
      router.push('/auth?redirect=/browse&message=' + encodeURIComponent('Iniciar sesión para continuar con el contacto'));
      return;
    }
    if (phone) {
      window.open(`https://wa.me/${phone}`, '_blank');
    }
  };

  const renderStars = (rating: number) => {
    return Array.from({ length: 5 }).map((_, i) => (
      <Star
        key={i}
        className={`w-4 h-4 ${
          i < rating ? 'fill-yellow-400 text-yellow-400' : 'text-gray-400'
        }`}
      />
    ));
  };

  const filteredSellers = sellers.filter((seller) => {
    const cityMatch = !selectedCity || seller.city === selectedCity;
    const categoryMatch = !selectedCategory || (seller.categories && seller.categories.includes(selectedCategory));
    return cityMatch && categoryMatch;
  });

  const getCategoryName = (categoryId: string) => {
    const cat = categories.find(c => c.id === categoryId);
    return cat ? cat.name : categoryId;
  };

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="liquid-glass sticky top-0 z-50">
        <div className="container mx-auto px-4 py-3 sm:py-4 flex justify-between items-center">
          <button
            onClick={() => router.push('/')}
            className="flex items-center gap-2 text-white hover:text-white/80 transition"
          >
            <Home className="w-5 h-5 sm:w-6 sm:h-6" />
            <span className="font-semibold text-sm sm:text-base">ServiCenter</span>
          </button>
          <div className="flex items-center gap-2 sm:gap-4">
            {user ? (
              <span className="text-white text-xs sm:text-sm truncate max-w-[100px] sm:max-w-none">{user.email}</span>
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

      {/* Hero/Title */}
      <section className="container mx-auto px-4 py-6 sm:py-8">
        <div className="text-center mb-6 sm:mb-8">
          <h1 className="text-3xl sm:text-4xl font-bold text-white mb-3 sm:mb-4">
            Profesionales en Todo Colombia
          </h1>
          <p className="text-lg sm:text-xl text-white/70 px-2">
            Encuentra el experto perfecto para tu hogar
          </p>
        </div>

        {/* Filters */}
        <div className="liquid-glass rounded-2xl p-4 sm:p-6 mb-6 sm:mb-8">
          <div className="flex items-center gap-2 mb-3 sm:mb-4">
            <Filter className="w-5 h-5 text-white" />
            <h2 className="text-base sm:text-lg font-semibold text-white">Filtrar por</h2>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-3 sm:gap-4">
            <div>
              <label className="block text-white mb-1 sm:mb-2 text-sm">Ciudad / Pueblo</label>
              <select
                value={selectedCity}
                onChange={(e) => setSelectedCity(e.target.value)}
                className="w-full px-3 py-2.5 sm:px-4 sm:py-3 rounded-xl glass text-white focus:outline-none focus:ring-2 focus:ring-white/50 text-sm sm:text-base"
              >
                <option value="" className="bg-gray-800">Todas las ciudades</option>
                {citiesColombia.map((city) => (
                  <option key={city.id} value={city.name} className="bg-gray-800">
                    {city.name}, {city.department}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <label className="block text-white mb-1 sm:mb-2 text-sm">Categoría</label>
              <select
                value={selectedCategory}
                onChange={(e) => setSelectedCategory(e.target.value)}
                className="w-full px-3 py-2.5 sm:px-4 sm:py-3 rounded-xl glass text-white focus:outline-none focus:ring-2 focus:ring-white/50 text-sm sm:text-base"
              >
                <option value="" className="bg-gray-800">Todas las categorías</option>
                {categories.map((cat) => (
                  <option key={cat.id} value={cat.id} className="bg-gray-800">
                    {cat.icon} {cat.name}
                  </option>
                ))}
              </select>
            </div>
          </div>
        </div>
      </section>

      {/* Results */}
      <main className="container mx-auto px-4 pb-12">
        {loading ? (
          <div className="flex justify-center items-center">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-white"></div>
          </div>
        ) : filteredSellers.length === 0 ? (
          <div className="liquid-glass rounded-2xl p-12 text-center">
            <p className="text-white text-xl">
              No hay profesionales disponibles con los filtros seleccionados.
            </p>
          </div>
        ) : (
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredSellers.map((seller) => (
              <div 
                key={seller.id} 
                className="liquid-glass rounded-2xl p-6 hover:scale-[1.02] transition-transform relative overflow-hidden"
                onClick={() => {
                  if (!user) {
                    router.push('/auth?redirect=/browse&message=' + encodeURIComponent('Iniciar sesión para ver el perfil del vendedor'));
                  }
                }}
              >
                {!user && (
                  <div className="absolute inset-0 backdrop-blur-md bg-black/40 flex items-center justify-center z-10">
                    <button 
                      onClick={(e) => {
                        e.stopPropagation();
                        router.push('/auth?redirect=/browse&message=' + encodeURIComponent('Iniciar sesión para ver el perfil del vendedor'));
                      }}
                      className="glass-strong px-4 py-2 rounded-lg text-white text-sm hover:bg-white/30 transition"
                    >
                      Iniciar sesión para ver perfil
                    </button>
                  </div>
                )}
                {/* Header */}
                <div className="flex items-start justify-between mb-4">
                  <div className="flex items-center gap-3">
                    <div className="w-12 h-12 rounded-full glass-strong flex items-center justify-center">
                      <span className="text-2xl">👷</span>
                    </div>
                    <div>
                      <h3 className="text-lg font-semibold text-white">
                        {seller.full_name || 'Profesional'}
                      </h3>
                      <div className="flex items-center gap-1 text-white/70 text-sm">
                        <MapPin className="w-3 h-3" />
                        {seller.city}
                      </div>
                    </div>
                  </div>
                  {seller.is_verified && (
                    <div className="flex items-center gap-1 text-green-400" title="Verificado">
                      <CheckCircle className="w-5 h-5" />
                      <Shield className="w-4 h-4" />
                    </div>
                  )}
                </div>

                {/* Categories */}
                {seller.categories && seller.categories.length > 0 && (
                  <div className="flex flex-wrap gap-1 mb-3">
                    {seller.categories.slice(0, 3).map((catId) => (
                      <span key={catId} className="text-xs px-2 py-1 rounded-full glass text-white/80">
                        {getCategoryName(catId)}
                      </span>
                    ))}
                    {seller.categories.length > 3 && (
                      <span className="text-xs px-2 py-1 rounded-full glass text-white/80">
                        +{seller.categories.length - 3}
                      </span>
                    )}
                  </div>
                )}

                {/* Rating */}
                <div className="flex items-center gap-2 mb-4">
                  <div className="flex">
                    {renderStars(Math.round(seller.rating || 0))}
                  </div>
                  <span className="text-white/70 text-sm">
                    ({seller.review_count || 0} reviews)
                  </span>
                </div>

                {/* Description */}
                {seller.description && (
                  <p className="text-white/80 text-sm mb-4 line-clamp-3">
                    {seller.description}
                  </p>
                )}

                {/* Contact Info */}
                <div className="text-sm text-white/60 mb-4">
                  <span className="font-semibold">Contacto: </span>
                  {seller.preferred_contact === 'whatsapp' && 'WhatsApp'}
                  {seller.preferred_contact === 'chat' && 'Chat interno'}
                  {seller.preferred_contact === 'both' && 'WhatsApp y Chat'}
                </div>

                {/* Action Buttons */}
                <div className="flex gap-2 relative z-20">
                  <button
                    onClick={(e) => {
                      e.stopPropagation();
                      handleContact(seller.id);
                    }}
                    className="flex-1 glass px-4 py-2 rounded-lg text-white hover:bg-white/20 transition flex items-center justify-center gap-2"
                  >
                    <MessageCircle className="w-4 h-4" />
                    Chat
                  </button>
                  {seller.preferred_contact !== 'chat' && seller.whatsapp && (
                    <button
                      onClick={(e) => {
                        e.stopPropagation();
                        openWhatsApp(seller.whatsapp!);
                      }}
                      className="flex-1 glass px-4 py-2 rounded-lg text-white hover:bg-white/20 transition flex items-center justify-center gap-2"
                    >
                      <Phone className="w-4 h-4" />
                      WhatsApp
                    </button>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}
      </main>
    </div>
  );
}

export default function BrowsePage() {
  return (
    <Suspense fallback={<div className="min-h-screen flex items-center justify-center"><div className="animate-spin rounded-full h-12 w-12 border-b-2 border-white"></div></div>}>
      <BrowseContent />
    </Suspense>
  );
}
