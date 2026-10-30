'use client';

import { useState, useEffect, Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { supabase } from '@/lib/supabase';
import { Star, MessageCircle, Phone, CheckCircle, Shield, ArrowLeft, MapPin } from 'lucide-react';

function SellerProfileContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const sellerId = searchParams.get('id');

  const [seller, setSeller] = useState<any>(null);
  const [reviews, setReviews] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [user, setUser] = useState<any>(null);
  const [newReview, setNewReview] = useState({ rating: 5, comment: '' });
  const [submitting, setSubmitting] = useState(false);
  const [replyingTo, setReplyingTo] = useState<string | null>(null);
  const [replyText, setReplyText] = useState('');

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
      .select('*, users(full_name, username)')
      .eq('seller_id', sellerId)
      .is('parent_id', null)
      .order('created_at', { ascending: false });

    if (error) {
      console.error('Error fetching reviews:', error);
      setReviews([]);
    } else {
      // Fetch replies for each review
      const reviewsWithReplies = await Promise.all(
        (data || []).map(async (review) => {
          const { data: replies } = await supabase
            .from('reviews')
            .select('*, users(full_name, username)')
            .eq('parent_id', review.id)
            .order('created_at', { ascending: true });
          return { ...review, replies: replies || [] };
        })
      );
      setReviews(reviewsWithReplies);
    }
  };

  const submitReview = async () => {
    if (!user) {
      alert('Debes iniciar sesión para dejar una reseña');
      return;
    }

    setSubmitting(true);
    try {
      const { data, error } = await supabase
        .from('reviews')
        .insert({
          seller_id: sellerId,
          user_id: user.id,
          rating: newReview.rating,
          comment: newReview.comment,
        })
        .select('*, users(full_name, username)')
        .single();

      if (error) throw error;

      // Agregar la nueva reseña al estado local inmediatamente
      if (data) {
        setReviews([{ ...data, replies: [] }, ...reviews]);
      }

      alert('Reseña enviada exitosamente');
      setNewReview({ rating: 5, comment: '' });
    } catch (err) {
      console.error('Error submitting review:', err);
      alert('Error al enviar la reseña');
    } finally {
      setSubmitting(false);
    }
  };

  const submitReply = async (parentId: string) => {
    if (!user) {
      alert('Debes iniciar sesión para responder');
      return;
    }

    if (!replyText.trim()) {
      alert('Escribe tu respuesta');
      return;
    }

    setSubmitting(true);
    try {
      const { error } = await supabase
        .from('reviews')
        .insert({
          seller_id: sellerId,
          user_id: user.id,
          parent_id: parentId,
          comment: replyText,
        });

      if (error) throw error;

      alert('Respuesta enviada exitosamente');
      setReplyText('');
      setReplyingTo(null);
      fetchReviews();
    } catch (err) {
      console.error('Error submitting reply:', err);
      alert('Error al enviar la respuesta');
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

  const calculateAverageRating = () => {
    if (reviews.length === 0) return 0;
    const total = reviews.reduce((sum, review) => sum + (review.rating || 0), 0);
    return Math.round(total / reviews.length);
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

  if (!user) {
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
          <div className="liquid-glass rounded-2xl p-8 sm:p-12 text-center">
            <h2 className="text-2xl sm:text-3xl font-bold text-white mb-4">
              Inicia sesión para ver el perfil completo
            </h2>
            <p className="text-white/70 mb-6">
              Necesitas iniciar sesión para ver el perfil del vendedor, contactarlo, ver reseñas y dejar comentarios.
            </p>
            <button
              onClick={() => router.push(`/auth?redirect=/seller-profile?id=${sellerId}`)}
              className="glass-strong px-6 py-3 rounded-lg text-white hover:bg-white/30 transition"
            >
              Iniciar Sesión
            </button>
          </div>
        </main>
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
                  {renderStars(calculateAverageRating())}
                </div>
                <span className="text-white/70">
                  ({reviews.length} reseñas)
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
                    <div className="flex items-center gap-2">
                      <span className="font-semibold text-white">
                        {review.users?.username || review.users?.full_name || 'Usuario'}
                      </span>
                      {review.users?.service_confirmed && (
                        <span className="text-xs bg-green-500/20 text-green-400 px-2 py-1 rounded-full">
                          ✓ Servicio contratado
                        </span>
                      )}
                    </div>
                    {review.rating && (
                      <div className="flex">
                        {renderStars(review.rating)}
                      </div>
                    )}
                  </div>
                  <p className="text-white/80 text-sm mb-2">{review.comment}</p>
                  <div className="flex items-center justify-between">
                    <p className="text-white/40 text-xs">
                      {new Date(review.created_at).toLocaleDateString('es-ES')}
                    </p>
                    <button
                      onClick={() => setReplyingTo(review.id)}
                      className="text-white/60 text-xs hover:text-white transition"
                    >
                      Responder
                    </button>
                  </div>

                  {/* Reply Form */}
                  {replyingTo === review.id && (
                    <div className="mt-4 p-3 glass rounded-lg">
                      <textarea
                        value={replyText}
                        onChange={(e) => setReplyText(e.target.value)}
                        placeholder="Escribe tu respuesta..."
                        className="w-full p-2 rounded-lg bg-white/10 text-white border border-white/20 focus:border-white/40 outline-none resize-none text-sm"
                        rows={2}
                      />
                      <div className="flex gap-2 mt-2">
                        <button
                          onClick={() => submitReply(review.id)}
                          disabled={submitting}
                          className="glass px-3 py-1 rounded-lg text-white text-sm hover:bg-white/20 transition disabled:opacity-50"
                        >
                          {submitting ? 'Enviando...' : 'Enviar'}
                        </button>
                        <button
                          onClick={() => setReplyingTo(null)}
                          className="glass px-3 py-1 rounded-lg text-white text-sm hover:bg-white/20 transition"
                        >
                          Cancelar
                        </button>
                      </div>
                    </div>
                  )}

                  {/* Replies */}
                  {review.replies && review.replies.length > 0 && (
                    <div className="mt-4 ml-4 space-y-3 border-l-2 border-white/20 pl-4">
                      {review.replies.map((reply: any) => (
                        <div key={reply.id} className="p-3 glass rounded-lg">
                          <div className="flex items-center gap-2 mb-2">
                            <span className="font-semibold text-white text-sm">
                              {reply.users?.username || reply.users?.full_name || 'Usuario'}
                            </span>
                            {reply.users?.service_confirmed && (
                              <span className="text-xs bg-green-500/20 text-green-400 px-2 py-1 rounded-full">
                                ✓ Servicio contratado
                              </span>
                            )}
                          </div>
                          <p className="text-white/80 text-sm">{reply.comment}</p>
                          <p className="text-white/40 text-xs mt-1">
                            {new Date(reply.created_at).toLocaleDateString('es-ES')}
                          </p>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>
      </main>
    </div>
  );
}

export default function SellerProfilePage() {
  return (
    <Suspense fallback={<div className="min-h-screen flex items-center justify-center"><div className="animate-spin rounded-full h-12 w-12 border-b-2 border-white"></div></div>}>
      <SellerProfileContent />
    </Suspense>
  );
}
