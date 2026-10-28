'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { supabase } from '@/lib/supabase';
import { MessageCircle, Star, ArrowLeft, Settings, LogOut, BarChart3 } from 'lucide-react';

export default function SellerDashboardPage() {
  const router = useRouter();
  const [user, setUser] = useState<any>(null);
  const [conversations, setConversations] = useState<any[]>([]);
  const [reviews, setReviews] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

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

      if (userData?.role === 'seller') {
        setUser(userData);
        fetchConversations(session.user.id);
        fetchReviews(session.user.id);
      } else {
        router.push('/categories');
      }
    } else {
      router.push('/auth');
    }
    setLoading(false);
  };

  const fetchConversations = async (userId: string) => {
    const { data, error } = await supabase
      .from('conversations')
      .select('*, users(full_name)')
      .eq('seller_id', userId)
      .order('last_message_time', { ascending: false });

    if (error) console.error('Error fetching conversations:', error);
    else setConversations(data || []);
  };

  const fetchReviews = async (sellerId: string) => {
    const { data, error } = await supabase
      .from('reviews')
      .select('*, users(full_name, username)')
      .eq('seller_id', sellerId)
      .order('created_at', { ascending: false });

    if (error) console.error('Error fetching reviews:', error);
    else setReviews(data || []);
  };

  const handleLogout = async () => {
    await supabase.auth.signOut();
    router.push('/');
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-white"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="liquid-glass sticky top-0 z-50">
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <button
              onClick={() => router.push('/categories')}
              className="text-white hover:text-white/80 transition"
            >
              <ArrowLeft className="w-6 h-6" />
            </button>
            <h1 className="text-xl font-bold text-white">Panel de Vendedor</h1>
          </div>
          <div className="flex items-center gap-2">
            <button
              onClick={() => router.push('/profile')}
              className="glass px-3 py-2 rounded-lg text-white hover:bg-white/20 transition flex items-center gap-2"
            >
              <Settings className="w-4 h-4" />
              Perfil
            </button>
            <button
              onClick={handleLogout}
              className="glass px-3 py-2 rounded-lg text-white hover:bg-white/20 transition flex items-center gap-2"
            >
              <LogOut className="w-4 h-4" />
              Cerrar
            </button>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        {/* Stats Cards */}
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-8">
          <div className="liquid-glass rounded-2xl p-6">
            <div className="flex items-center gap-3 mb-2">
              <MessageCircle className="w-8 h-8 text-white/70" />
              <span className="text-white/70">Conversaciones</span>
            </div>
            <p className="text-3xl font-bold text-white">{conversations.length}</p>
          </div>
          <div className="liquid-glass rounded-2xl p-6">
            <div className="flex items-center gap-3 mb-2">
              <Star className="w-8 h-8 text-white/70" />
              <span className="text-white/70">Reseñas</span>
            </div>
            <p className="text-3xl font-bold text-white">{reviews.length}</p>
          </div>
          <div className="liquid-glass rounded-2xl p-6">
            <div className="flex items-center gap-3 mb-2">
              <BarChart3 className="w-8 h-8 text-white/70" />
              <span className="text-white/70">Calificación</span>
            </div>
            <p className="text-3xl font-bold text-white">{user?.rating?.toFixed(1) || '0.0'}</p>
          </div>
        </div>

        {/* Conversations */}
        <div className="liquid-glass rounded-2xl p-6 mb-8">
          <h2 className="text-2xl font-bold text-white mb-4">Conversaciones Recientes</h2>
          {conversations.length === 0 ? (
            <p className="text-white/60">No hay conversaciones aún</p>
          ) : (
            <div className="space-y-3">
              {conversations.slice(0, 5).map((conv) => (
                <button
                  key={conv.id}
                  onClick={() => router.push(`/chat?seller=${user.id}`)}
                  className="w-full p-4 glass rounded-xl text-left hover:bg-white/20 transition"
                >
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full glass-strong flex items-center justify-center">
                        <span className="text-xl">👤</span>
                      </div>
                      <div>
                        <p className="text-white font-semibold">
                          {conv.users?.full_name || 'Usuario'}
                        </p>
                        {conv.last_message && (
                          <p className="text-white/60 text-sm truncate">
                            {conv.last_message}
                          </p>
                        )}
                      </div>
                    </div>
                  </div>
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Reviews */}
        <div className="liquid-glass rounded-2xl p-6">
          <h2 className="text-2xl font-bold text-white mb-4">Reseñas Recientes</h2>
          {reviews.length === 0 ? (
            <p className="text-white/60">No hay reseñas aún</p>
          ) : (
            <div className="space-y-3">
              {reviews.slice(0, 5).map((review) => (
                <div key={review.id} className="p-4 glass rounded-xl">
                  <div className="flex items-center justify-between mb-2">
                    <span className="font-semibold text-white">
                      {review.users?.username || review.users?.full_name || 'Usuario'}
                    </span>
                    <div className="flex">
                      {[1, 2, 3, 4, 5].map((star) => (
                        <Star
                          key={star}
                          className={`w-4 h-4 ${
                            star <= (review.rating || 0) ? 'fill-yellow-400 text-yellow-400' : 'text-gray-400'
                          }`}
                        />
                      ))}
                    </div>
                  </div>
                  <p className="text-white/80 text-sm">{review.comment}</p>
                </div>
              ))}
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
