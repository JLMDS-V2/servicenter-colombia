'use client';

import { useState, useEffect, Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { supabase } from '@/lib/supabase';
import { Seller, Review } from '@/types';
import { Star, MessageCircle, Phone, CheckCircle, Shield, ArrowLeft, MapPin } from 'lucide-react';

function SellersContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const category = searchParams.get('category') || '';
  const categoryName = searchParams.get('name') || 'Servicios';

  const [sellers, setSellers] = useState<Seller[]>([]);
  const [loading, setLoading] = useState(true);
  const [userCity, setUserCity] = useState('');

  useEffect(() => {
    fetchSellers();
    fetchUserCity();
  }, [category]);

  const fetchUserCity = async () => {
    const { data: { session } } = await supabase.auth.getSession();
    if (session?.user) {
      const { data: userData } = await supabase
        .from('users')
        .select('city')
        .eq('id', session.user.id)
        .single();
      setUserCity(userData?.city || searchParams.get('city') || '');
    } else {
      setUserCity(searchParams.get('city') || '');
    }
  };

  const fetchSellers = async () => {
    setLoading(true);
    try {
      let query = supabase
        .from('users')
        .select('*')
        .eq('role', 'seller')
        .contains('categories', [category]);

      // Filtrar por ciudad si está seleccionada
      if (userCity) {
        query = query.eq('city', userCity);
      }

      const { data, error } = await query;

      if (error) throw error;
      setSellers(data || []);
    } catch (err) {
      console.error('Error fetching sellers:', err);
    } finally {
      setLoading(false);
    }
  };

  const openChat = async (sellerId: string) => {
    const { data: { session } } = await supabase.auth.getSession();
    if (!session) {
      router.push(`/auth?redirect=/sellers?category=${category}&name=${encodeURIComponent(categoryName)}&city=${userCity}&message=${encodeURIComponent('Inicia sesión para contactar al vendedor')}`);
      return;
    }
    router.push(`/chat?seller=${sellerId}`);
  };

  const openWhatsApp = async (phone: string) => {
    const { data: { session } } = await supabase.auth.getSession();
    if (!session) {
      router.push(`/auth?redirect=/sellers?category=${category}&name=${encodeURIComponent(categoryName)}&city=${userCity}&message=${encodeURIComponent('Inicia sesión para contactar al vendedor')}`);
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

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="liquid-glass sticky top-0 z-50">
        <div className="container mx-auto px-4 py-3 sm:py-4 flex items-center gap-3 sm:gap-4">
          <button
            onClick={() => router.push('/categories')}
            className="text-white hover:text-white/80 transition"
          >
            <ArrowLeft className="w-5 h-5 sm:w-6 sm:h-6" />
          </button>
          <h1 className="text-lg sm:text-xl font-bold text-white truncate">
            {categoryName} en {userCity || 'Colombia'}
          </h1>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8 sm:py-12">
        {loading ? (
          <div className="flex justify-center items-center">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-white"></div>
          </div>
        ) : sellers.length === 0 ? (
          <div className="liquid-glass rounded-2xl p-8 sm:p-12 text-center">
            <p className="text-white text-lg sm:text-xl">
              No hay vendedores disponibles en esta categoría aún.
            </p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-6">
            {sellers.map((seller) => (
              <div key={seller.id} className="liquid-glass rounded-2xl p-4 sm:p-6">
                {/* Header */}
                <div className="flex items-start justify-between mb-3 sm:mb-4">
                  <div className="flex items-center gap-2 sm:gap-3">
                    <div className="w-10 h-10 sm:w-12 sm:h-12 rounded-full glass-strong flex items-center justify-center flex-shrink-0">
                      <span className="text-xl sm:text-2xl">👷</span>
                    </div>
                    <div className="min-w-0">
                      <h3 className="text-base sm:text-lg font-semibold text-white truncate">
                        {seller.full_name || 'Profesional'}
                      </h3>
                      <div className="flex items-center gap-1 text-white/70 text-xs sm:text-sm">
                        <MapPin className="w-3 h-3" />
                        <span className="truncate">{seller.city}</span>
                      </div>
                    </div>
                  </div>
                  {seller.is_verified && (
                    <div className="flex items-center gap-1 text-green-400 flex-shrink-0" title="Verificado">
                      <CheckCircle className="w-4 h-4 sm:w-5 sm:h-5" />
                      <Shield className="w-3 h-3 sm:w-4 sm:h-4" />
                    </div>
                  )}
                </div>

                {/* Rating */}
                <div className="flex items-center gap-2 mb-3 sm:mb-4">
                  <div className="flex">
                    {renderStars(Math.round(seller.rating || 0))}
                  </div>
                  <span className="text-white/70 text-xs sm:text-sm">
                    ({seller.review_count || 0} reviews)
                  </span>
                </div>

                {/* Description */}
                {seller.description && (
                  <p className="text-white/80 text-xs sm:text-sm mb-3 sm:mb-4 line-clamp-2 sm:line-clamp-3">
                    {seller.description}
                  </p>
                )}

                {/* Contact Info */}
                <div className="text-xs sm:text-sm text-white/60 mb-3 sm:mb-4">
                  <span className="font-semibold">Contacto: </span>
                  {seller.preferred_contact === 'whatsapp' && 'WhatsApp'}
                  {seller.preferred_contact === 'chat' && 'Chat interno'}
                  {seller.preferred_contact === 'both' && 'WhatsApp y Chat'}
                </div>

                {/* Action Buttons */}
                <div className="flex gap-2 flex-col sm:flex-row">
                  <button
                    onClick={() => openChat(seller.id)}
                    className="flex-1 glass px-3 py-2 sm:px-4 rounded-lg text-white hover:bg-white/20 transition flex items-center justify-center gap-2 text-xs sm:text-sm sm:text-base"
                  >
                    <MessageCircle className="w-4 h-4" />
                    Chat
                  </button>
                  {seller.preferred_contact !== 'chat' && seller.whatsapp && (
                    <button
                      onClick={() => seller.whatsapp && openWhatsApp(seller.whatsapp)}
                      className="flex-1 glass px-3 py-2 sm:px-4 rounded-lg text-white hover:bg-white/20 transition flex items-center justify-center gap-2 text-xs sm:text-sm sm:text-base"
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

      {/* Ad Space */}
      <section className="container mx-auto px-4 py-8">
        <div className="glass rounded-xl p-8 text-center">
          <p className="text-white/60 text-sm">Espacio para anuncios</p>
        </div>
      </section>
    </div>
  );
}

export default function SellersPage() {
  return (
    <Suspense fallback={<div className="min-h-screen flex items-center justify-center"><div className="animate-spin rounded-full h-12 w-12 border-b-2 border-white"></div></div>}>
      <SellersContent />
    </Suspense>
  );
}
