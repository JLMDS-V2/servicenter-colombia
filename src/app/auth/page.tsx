'use client';

import { useState, Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { supabase } from '@/lib/supabase';
import { citiesColombia } from '@/lib/data';
import { User, Lock, MapPin } from 'lucide-react';

function AuthContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const redirectPath = searchParams.get('redirect') || '/categories';
  const [isLogin, setIsLogin] = useState(true);
  const [identifier, setIdentifier] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [city, setCity] = useState('');
  const [username, setUsername] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [showEmailWarning, setShowEmailWarning] = useState(false);

  const handleAuth = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      if (isLogin) {
        // Verificar si es username o email
        let loginEmail = identifier;

        // Si no tiene @, asumir que es username y buscar el email en la base de datos
        if (!identifier.includes('@')) {
          const { data: userData } = await supabase
            .from('users')
            .select('email')
            .eq('username', identifier)
            .single();

          if (userData?.email) {
            loginEmail = userData.email;
          } else {
            throw new Error('Usuario no encontrado');
          }
        }

        const { data, error } = await supabase.auth.signInWithPassword({
          email: loginEmail,
          password,
        });

        if (error) throw error;

        // Verificar el rol del usuario y redirigir al dashboard correspondiente
        const { data: userData } = await supabase
          .from('users')
          .select('role')
          .eq('id', data.user.id)
          .single();

        if (userData?.role === 'seller') {
          router.push('/seller-dashboard');
        } else {
          router.push(redirectPath);
        }
      } else {
        // Si no hay email, generar uno temporal basado en el username
        const signupEmail = email || `${username}@temp.servicenter.local`;
        
        const { data, error } = await supabase.auth.signUp({
          email: signupEmail,
          password,
          options: {
            data: {
              role: 'user',
              city: city,
              username: username,
            },
          },
        });

        if (error) throw error;

        if (data.user) {
          await new Promise(resolve => setTimeout(resolve, 500));
          router.push(redirectPath);
        } else {
          throw new Error('No se pudo crear el usuario');
        }
      }
    } catch (err: any) {
      setError(err.message || 'Error en la autenticación');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      <div className="liquid-glass rounded-3xl p-8 w-full max-w-md">
        <div className="text-center mb-8">
          <div className="flex items-center justify-center gap-2 mb-4">
            <img src="/icon.png" alt="ServiCenter" className="w-12 h-12" />
          </div>
          <h1 className="text-3xl font-bold text-white mb-2">
            {isLogin ? 'Iniciar Sesión' : 'Crear Cuenta'}
          </h1>
          <p className="text-white/70">
            {searchParams.get('message') || (isLogin ? 'Bienvenido de nuevo' : 'Únete a ServiCenter')}
          </p>
        </div>

        <form onSubmit={handleAuth} className="space-y-6">
          <div>
            <label className="block text-white mb-2 flex items-center gap-2">
              <User className="w-4 h-4" />
              Nombre de Usuario
            </label>
            <input
              type="text"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              required={!isLogin}
              className="w-full px-4 py-3 rounded-xl glass text-white placeholder-white/50 focus:outline-none focus:ring-2 focus:ring-white/50"
              placeholder="Tu nombre de usuario"
            />
          </div>

          {!isLogin && (
            <div>
              <label className="block text-white mb-2 flex items-center gap-2">
                <User className="w-4 h-4" />
                Correo Electrónico (Opcional)
              </label>
              <input
                type="email"
                value={email}
                onChange={(e) => {
                  setEmail(e.target.value);
                  setShowEmailWarning(e.target.value === '');
                }}
                className="w-full px-4 py-3 rounded-xl glass text-white placeholder-white/50 focus:outline-none focus:ring-2 focus:ring-white/50"
                placeholder="tu@email.com"
              />
              {showEmailWarning && (
                <p className="text-yellow-400 text-xs mt-1">
                  ⚠️ Si no pones correo, tienes la posibilidad de perder la cuenta
                </p>
              )}
            </div>
          )}

          {isLogin && (
            <div>
              <label className="block text-white mb-2 flex items-center gap-2">
                <User className="w-4 h-4" />
                Nombre de usuario o Email
              </label>
              <input
                type="text"
                value={identifier}
                onChange={(e) => setIdentifier(e.target.value)}
                required
                className="w-full px-4 py-3 rounded-xl glass text-white placeholder-white/50 focus:outline-none focus:ring-2 focus:ring-white/50"
                placeholder="Nombre de usuario o email"
              />
            </div>
          )}

          <div>
            <label className="block text-white mb-2 flex items-center gap-2">
              <Lock className="w-4 h-4" />
              Contraseña
            </label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              minLength={6}
              className="w-full px-4 py-3 rounded-xl glass text-white placeholder-white/50 focus:outline-none focus:ring-2 focus:ring-white/50"
              placeholder="••••••••"
            />
          </div>

          {!isLogin && (
            <div>
              <label className="block text-white mb-2 flex items-center gap-2">
                <MapPin className="w-4 h-4" />
                Ciudad (opcional)
              </label>
              <select
                value={city}
                onChange={(e) => setCity(e.target.value)}
                className="w-full px-4 py-3 rounded-xl glass text-white focus:outline-none focus:ring-2 focus:ring-white/50"
              >
                <option value="" className="bg-gray-800">Selecciona tu ciudad (opcional)</option>
                {citiesColombia.map((c) => (
                  <option key={c.id} value={c.name} className="bg-gray-800">
                    {c.name}, {c.department}
                  </option>
                ))}
              </select>
            </div>
          )}

          {error && (
            <div className="glass-dark px-4 py-3 rounded-xl text-red-300 text-sm">
              {error}
            </div>
          )}

          {searchParams.get('message') && (
            <div className="glass px-4 py-3 rounded-xl text-blue-300 text-sm">
              {searchParams.get('message')}
            </div>
          )}

          <button
            type="submit"
            disabled={loading}
            className="w-full glass-strong px-6 py-3 rounded-xl text-white font-semibold hover:bg-white/30 transition disabled:opacity-50"
          >
            {loading ? 'Procesando...' : isLogin ? 'Iniciar Sesión' : 'Crear Cuenta'}
          </button>
        </form>

        <div className="mt-6 text-center">
          <button
            onClick={() => setIsLogin(!isLogin)}
            className="text-white/70 hover:text-white transition"
          >
            {isLogin ? '¿No tienes cuenta? Regístrate' : '¿Ya tienes cuenta? Inicia sesión'}
          </button>
        </div>
      </div>
    </div>
  );
}

export default function AuthPage() {
  return (
    <Suspense fallback={<div className="min-h-screen flex items-center justify-center"><div className="animate-spin rounded-full h-12 w-12 border-b-2 border-white"></div></div>}>
      <AuthContent />
    </Suspense>
  );
}
