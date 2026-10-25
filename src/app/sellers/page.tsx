'use client';

import { useState, useEffect } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { supabase } from '@/lib/supabase';
import { Seller, Review } from '@/types';
import { Star, MessageCircle, WhatsApp, CheckCircle, Shield, ArrowLeft, MapPin } from 'lucide-react';

export default function SellersPage() {
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
      setUserCity(userData?.city || '');
    }
  };

  const fetchSellers = async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('users')
        .select('*')
        .eq('role', 'seller')
        .contains('categories', [category]);

      if (error) throw error;
      setSellers(data || []);
    } catch (err) {
      console.error('Error fetching sellers:', err);
    } finally {
      setLoading(false);
    }
  };

  const openChat = (sellerId: string) => {
    router.push(`/chat?seller=${sellerId}`);
  };

  const openWhatsApp = (phone: string) => {
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
        <div className="container mx-auto px-4 py-4 flex items-center gap-4">
          <button
            onClick={() => router.push('/categories')}
            className="text-white hover:text-white/80 transition"
          >
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl font-bold text-white">
            {categoryName} en {userCity || 'Colombia'}
          </h1>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-12">
        {loading ? (
          <div className="flex justify-center items-center">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-white"></div>
          </div>
        ) : sellers.length === 0 ? (
          <div className="liquid-glass rounded-2xl p-12 text-center">
            <p className="text-white text-xl">
              No hay vendedores disponibles en esta categoría aún.
            </p>
          </div>
        ) : (
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {sellers.map((seller) => (
              <div key={seller.id} className="liquid-glass rounded-2xl p-6">
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
                <div className="flex gap-2">
                  <button
                    onClick={() => openChat(seller.id)}
                    className="flex-1 glass px-4 py-2 rounded-lg text-white hover:bg-white/20 transition flex items-center justify-center gap-2"
                  >
                    <MessageCircle className="w-4 h-4" />
                    Chat
                  </button>
                  {seller.preferred_contact !== 'chat' && seller.whatsapp && (
                    <button
                      onClick={() => openWhatsApp(seller.whatsapp)}
                      className="flex-1 glass px-4 py-2 rounded-lg text-white hover:bg-white/20 transition flex items-center justify-center gap-2"
                    >
                      <WhatsApp className="w-4 h-4" />
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
