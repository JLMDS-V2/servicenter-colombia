'use client';

import { useState, useEffect } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { supabase } from '@/lib/supabase';
import { Star, MessageCircle, Phone, CheckCircle, Shield, ArrowLeft, MapPin } from 'lucide-react';

export default function SellerProfilePage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const sellerId = searchParams.get('id');

  const [seller, setSeller] = useState<any>(null);
  const [reviews, setReviews] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [user, setUser] = useState<any>(null);
  const [newReview, setNewReview] = useState({ rating: 5, comment: '' });
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    checkUser();
    if (sellerId) {
      fetchSeller();
      fetchReviews();
    }
  }, [sellerId]);

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

  const fetchSeller = async () => {
    const { data, error } = await supabase
      .from('users')
      .select('*')
      .eq('id', sellerId)
      .single();

    if (error) {
      console.error('Error fetching seller:', error);
    } else {
      setSeller(data);
    }
    setLoading(false);
  };

  const fetchReviews = async () => {
    const { data, error } = await supabase
      .from('reviews')
      .select('*, users(full_name)')
      .eq('seller_id', sellerId)
      .order('created_at', { ascending: false });

    if (error) {
      console.error('Error fetching reviews:', error);
    } else {
      setReviews(data || []);
    }
  };

  const submitReview = async () => {
    if (!user) {
      alert('Debes iniciar sesión para dejar una reseña');
      return;
    }

    setSubmitting(true);
    try {
      const { error } = await supabase
        .from('reviews')
        .insert({
          seller_id: sellerId,
          user_id: user.id,
          rating: newReview.rating,
          comment: newReview.comment,
        });

      if (error) throw error;

      alert('Reseña enviada exitosamente');
      setNewReview({ rating: 5, comment: '' });
      fetchReviews();
    } catch (err) {
      console.error('Error submitting review:', err);
      alert('Error al enviar la reseña');
    } finally {
      setSubmitting(false);
    }
  };

  const openChat = async () => {
    if (!user) {
      router.push(`/auth?redirect=/seller-profile?id=${sellerId}`);
      return;
    }
    router.push(`/chat?seller=${sellerId}`);
  };

  const openWhatsApp = () => {
    if (seller?.whatsapp) {
      window.open(`https://wa.me/${seller.whatsapp}`, '_blank');
    }
  };

  const renderStars = (rating: number) => {
    const stars = [];
    for (let i = 0; i < 5; i++) {
      stars.push(
        <Star
          key={i}
          className={`w-5 h-5 ${
            i < rating ? 'fill-yellow-400 text-yellow-400' : 'text-gray-400'
          }`}
        />
      );
    }
    return stars;
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-white"></div>
      </div>
    );
  }

  if (!seller) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="liquid-glass rounded-2xl p-8 text-center">
          <p className="text-white">Vendedor no encontrado</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="liquid-glass sticky top-0 z-50">
        <div className="container mx-auto px-4 py-3 sm:py-4 flex items-center gap-3 sm:gap-4">
          <button
            onClick={() => router.back()}
            className="text-white hover:text-white/80 transition"
          >
            <ArrowLeft className="w-5 h-5 sm:w-6 sm:h-6" />
          </button>
          <h1 className="text-lg sm:text-xl font-bold text-white truncate">
            Perfil de {seller.full_name}
          </h1>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8 sm:py-12">
        {/* Seller Info Card */}
        <div className="liquid-glass rounded-2xl p-6 sm:p-8 mb-8">
          <div className="flex items-start gap-4 sm:gap-6 mb-6">
            <div className="w-16 h-16 sm:w-20 sm:h-20 rounded-full glass-strong flex items-center justify-center flex-shrink-0">
              <span className="text-3xl sm:text-4xl">👷</span>
            </div>
            <div className="flex-1">
              <div className="flex items-center gap-2 mb-2">
                <h2 className="text-2xl sm:text-3xl font-bold text-white">
                  {seller.full_name}
                </h2>
                {seller.is_verified && (
                  <div className="flex items-center gap-1 text-green-400" title="Verificado">
                    <CheckCircle className="w-5 h-5" />
                    <Shield className="w-4 h-4" />
                  </div>
                )}
              </div>
              <div className="flex items-center gap-2 text-white/70 mb-2">
                <MapPin className="w-4 h-4" />
                <span>{seller.city}</span>
              </div>
              <div className="flex items-center gap-2 mb-4">
                <div className="flex">
                  {renderStars(Math.round(seller.rating || 0))}
                </div>
                <span className="text-white/70">
                  ({seller.review_count || 0} reseñas)
                </span>
              </div>
            </div>
          </div>

          <div className="mb-6">
            <h3 className="text-lg font-semibold text-white mb-2">Descripción</h3>
            <p className="text-white/80 text-sm sm:text-base">
              {seller.description || 'Sin descripción'}
            </p>
          </div>

          <div className="mb-6">
            <h3 className="text-lg font-semibold text-white mb-2">Contacto</h3>
            <p className="text-white/60 text-sm">
              {seller.preferred_contact === 'whatsapp' && 'WhatsApp'}
              {seller.preferred_contact === 'chat' && 'Chat interno'}
              {seller.preferred_contact === 'both' && 'WhatsApp y Chat'}
            </p>
          </div>

          <div className="flex gap-3 flex-col sm:flex-row">
            <button
              onClick={openChat}
              className="flex-1 glass px-4 py-3 rounded-lg text-white hover:bg-white/20 transition flex items-center justify-center gap-2"
            >
              <MessageCircle className="w-5 h-5" />
              Chat
            </button>
            {seller.preferred_contact !== 'chat' && seller.whatsapp && (
              <button
                onClick={openWhatsApp}
                className="flex-1 glass px-4 py-3 rounded-lg text-white hover:bg-white/20 transition flex items-center justify-center gap-2"
              >
                <Phone className="w-5 h-5" />
                WhatsApp
              </button>
            )}
          </div>
        </div>

        {/* Reviews Section */}
        <div className="liquid-glass rounded-2xl p-6 sm:p-8">
          <h2 className="text-2xl font-bold text-white mb-6">Reseñas</h2>

          {/* Review Form */}
          {user && (
            <div className="mb-8 p-4 glass rounded-xl">
              <h3 className="text-lg font-semibold text-white mb-4">Dejar una reseña</h3>
              <div className="mb-4">
                <label className="block text-white mb-2">Calificación</label>
                <div className="flex gap-2">
                  {[1, 2, 3, 4, 5].map((rating) => (
                    <button
                      key={rating}
                      onClick={() => setNewReview({ ...newReview, rating })}
                      className={`text-2xl ${
                        rating <= newReview.rating ? 'text-yellow-400' : 'text-gray-400'
                      }`}
                    >
                      ★
                    </button>
                  ))}
                </div>
              </div>
              <div className="mb-4">
                <label className="block text-white mb-2">Comentario</label>
                <textarea
                  value={newReview.comment}
                  onChange={(e) => setNewReview({ ...newReview, comment: e.target.value })}
                  className="w-full p-3 rounded-lg bg-white/10 text-white border border-white/20 focus:border-white/40 outline-none resize-none"
                  rows={3}
                  placeholder="Escribe tu reseña..."
                />
              </div>
              <button
                onClick={submitReview}
                disabled={submitting}
                className="glass px-4 py-2 rounded-lg text-white hover:bg-white/20 transition disabled:opacity-50"
              >
                {submitting ? 'Enviando...' : 'Enviar reseña'}
              </button>
            </div>
          )}

          {/* Reviews List */}
          {reviews.length === 0 ? (
            <p className="text-white/60 text-center py-8">
              No hay reseñas aún. ¡Sé el primero en dejar una!
            </p>
          ) : (
            <div className="space-y-4">
              {reviews.map((review) => (
                <div key={review.id} className="p-4 glass rounded-xl">
                  <div className="flex items-center justify-between mb-2">
                    <span className="font-semibold text-white">
                      {review.users?.full_name || 'Usuario'}
                    </span>
                    <div className="flex">
                      {renderStars(review.rating)}
                    </div>
                  </div>
                  <p className="text-white/80 text-sm">{review.comment}</p>
                  <p className="text-white/40 text-xs mt-2">
                    {new Date(review.created_at).toLocaleDateString('es-ES')}
                  </p>
                </div>
              ))}
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
