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
        <div className="container mx-auto px-4 py-4 flex flex-col sm:flex-row justify-between items-center gap-3">
          <div className="flex items-center gap-2">
            <img src="/icon.png" alt="ServiCenter" className="w-7 h-7 sm:w-8 sm:h-8" />
            <h1 className="text-xl sm:text-2xl font-bold text-white">ServiCenter</h1>
          </div>
          {user ? (
            <div className="flex items-center gap-2 sm:gap-4">
              <span className="text-white text-sm sm:text-base truncate max-w-[120px] sm:max-w-none">{user.email}</span>
              <button
                onClick={handleLogout}
                className="glass px-3 py-2 sm:px-4 rounded-lg text-white hover:bg-white/20 transition text-sm sm:text-base"
              >
                Cerrar Sesión
              </button>
            </div>
          ) : (
            <button
              onClick={() => router.push('/auth')}
              className="glass px-3 py-2 sm:px-4 rounded-lg text-white hover:bg-white/20 transition text-sm sm:text-base"
            >
              Iniciar Sesión
            </button>
          )}
        </div>
      </header>

      {/* Hero Section */}
      <section className="container mx-auto px-4 py-8 sm:py-16">
        <div className="liquid-glass rounded-3xl p-6 sm:p-12 text-center">
          <Sparkles className="w-12 h-12 sm:w-16 sm:h-16 mx-auto mb-4 sm:mb-6 text-white" />
          <h2 className="text-3xl sm:text-5xl font-bold text-white mb-3 sm:mb-4 break-words px-2">
            Encuentra Profesionales de Confianza
          </h2>
          <p className="text-lg sm:text-xl text-white/80 mb-6 sm:mb-8 break-words px-2">
            Electricistas, plomeros, cerrajeros y más expertos del hogar en Colombia
          </p>
          <button
            onClick={() => router.push('/categories')}
            className="glass-strong px-6 py-3 sm:px-8 sm:py-4 rounded-xl text-white text-base sm:text-lg font-semibold hover:bg-white/30 transition"
          >
            Comenzar Ahora
          </button>
        </div>
      </section>

      {/* CTA para Vendedores */}
      <section className="container mx-auto px-4 py-6 sm:py-8">
        <div className="liquid-glass rounded-2xl p-6 sm:p-8 text-center">
          <h3 className="text-xl sm:text-2xl font-bold text-white mb-2">¿Ofreces servicios profesionales?</h3>
          <p className="text-white/70 mb-4 text-sm sm:text-base">Únete como profesional y llega a más clientes en Colombia</p>
          <button
            onClick={() => router.push('/auth?redirect=/profile&message=' + encodeURIComponent('Iniciar sesión para registrar tu cuenta de vendedor'))}
            className="glass px-5 py-2.5 sm:px-6 sm:py-3 rounded-xl text-white hover:bg-white/20 transition text-sm sm:text-base"
          >
            Registrarme como Vendedor
          </button>
        </div>
      </section>

      {/* Features */}
      <section className="container mx-auto px-4 py-8 sm:py-16">
        <h3 className="text-2xl sm:text-3xl font-bold text-white text-center mb-8 sm:mb-12">
          ¿Por qué elegirnos?
        </h3>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 sm:gap-8">
          <div className="liquid-glass rounded-2xl p-6 sm:p-8 text-center">
            <Shield className="w-10 h-10 sm:w-12 sm:h-12 mx-auto mb-3 sm:mb-4 text-white" />
            <h4 className="text-lg sm:text-xl font-semibold text-white mb-2">Verificados</h4>
            <p className="text-white/70 text-sm sm:text-base">
              Profesionales verificados con suscripciones activas
            </p>
          </div>
          <div className="liquid-glass rounded-2xl p-6 sm:p-8 text-center">
            <Star className="w-10 h-10 sm:w-12 sm:h-12 mx-auto mb-3 sm:mb-4 text-white" />
            <h4 className="text-lg sm:text-xl font-semibold text-white mb-2">Calificaciones</h4>
            <p className="text-white/70 text-sm sm:text-base">
              Sistema de reviews y estrellas para confiar
            </p>
          </div>
          <div className="liquid-glass rounded-2xl p-6 sm:p-8 text-center">
            <MessageCircle className="w-10 h-10 sm:w-12 sm:h-12 mx-auto mb-3 sm:mb-4 text-white" />
            <h4 className="text-lg sm:text-xl font-semibold text-white mb-2">Chat Directo</h4>
            <p className="text-white/70 text-sm sm:text-base">
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
      <footer className="liquid-glass mt-12 sm:mt-16">
        <div className="container mx-auto px-4 py-6 sm:py-8 text-center">
          <p className="text-white/70 text-sm sm:text-base">
            © 2024 ServiCenter Colombia. Todos los derechos reservados.
          </p>
        </div>
      </footer>
    </div>
  );
}
