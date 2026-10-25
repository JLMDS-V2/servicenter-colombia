'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { supabase } from '@/lib/supabase';
import { User } from '@/types';
import { Sparkles, Home, Shield, Star, MessageCircle } from 'lucide-react';

export default function HomePage() {
  const router = useRouter();
  const [user, setUser] = useState<User | null>(null);
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
      setUser(userData);
    }
    setLoading(false);
  };

  const handleLogout = async () => {
    await supabase.auth.signOut();
    setUser(null);
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="liquid-glass rounded-2xl p-8">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-white"></div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="liquid-glass sticky top-0 z-50">
        <div className="container mx-auto px-4 py-4 flex justify-between items-center">
          <div className="flex items-center gap-2">
            <Home className="w-8 h-8 text-white" />
            <h1 className="text-2xl font-bold text-white">Servicios Hogar</h1>
          </div>
          {user ? (
            <div className="flex items-center gap-4">
              <span className="text-white">{user.email}</span>
              <button
                onClick={handleLogout}
                className="glass px-4 py-2 rounded-lg text-white hover:bg-white/20 transition"
              >
                Cerrar Sesión
              </button>
            </div>
          ) : (
            <button
              onClick={() => router.push('/auth')}
              className="glass px-4 py-2 rounded-lg text-white hover:bg-white/20 transition"
            >
              Iniciar Sesión
            </button>
          )}
        </div>
      </header>

      {/* Hero Section */}
      <section className="container mx-auto px-4 py-16">
        <div className="liquid-glass rounded-3xl p-12 text-center">
          <Sparkles className="w-16 h-16 mx-auto mb-6 text-white" />
          <h2 className="text-5xl font-bold text-white mb-4">
            Encuentra Profesionales de Confianza
          </h2>
          <p className="text-xl text-white/80 mb-8">
            Electricistas, plomeros, cerrajeros y más expertos del hogar en Colombia
          </p>
          {!user ? (
            <button
              onClick={() => router.push('/auth')}
              className="glass-strong px-8 py-4 rounded-xl text-white text-lg font-semibold hover:bg-white/30 transition"
            >
              Comenzar Ahora
            </button>
          ) : (
            <button
              onClick={() => router.push('/categories')}
              className="glass-strong px-8 py-4 rounded-xl text-white text-lg font-semibold hover:bg-white/30 transition"
            >
              Ver Categorías
            </button>
          )}
        </div>
      </section>

      {/* Features */}
      <section className="container mx-auto px-4 py-16">
        <h3 className="text-3xl font-bold text-white text-center mb-12">
          ¿Por qué elegirnos?
        </h3>
        <div className="grid md:grid-cols-3 gap-8">
          <div className="liquid-glass rounded-2xl p-8 text-center">
            <Shield className="w-12 h-12 mx-auto mb-4 text-white" />
            <h4 className="text-xl font-semibold text-white mb-2">Verificados</h4>
            <p className="text-white/70">
              Profesionales verificados con suscripciones activas
            </p>
          </div>
          <div className="liquid-glass rounded-2xl p-8 text-center">
            <Star className="w-12 h-12 mx-auto mb-4 text-white" />
            <h4 className="text-xl font-semibold text-white mb-2">Calificaciones</h4>
            <p className="text-white/70">
              Sistema de reviews y estrellas para confiar
            </p>
          </div>
          <div className="liquid-glass rounded-2xl p-8 text-center">
            <MessageCircle className="w-12 h-12 mx-auto mb-4 text-white" />
            <h4 className="text-xl font-semibold text-white mb-2">Chat Directo</h4>
            <p className="text-white/70">
              Comunicación fácil por WhatsApp o chat interno
            </p>
          </div>
        </div>
      </section>

      {/* Ad Space */}
      <section className="container mx-auto px-4 py-8">
        <div className="glass rounded-xl p-8 text-center">
          <p className="text-white/60 text-sm">Espacio para anuncios</p>
        </div>
      </section>

      {/* Footer */}
      <footer className="liquid-glass mt-16">
        <div className="container mx-auto px-4 py-8 text-center">
          <p className="text-white/70">
            © 2024 Servicios del Hogar Colombia. Todos los derechos reservados.
          </p>
        </div>
      </footer>
    </div>
  );
}
