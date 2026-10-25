'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { supabase } from '@/lib/supabase';
import { citiesColombia } from '@/lib/data';
import { UserRole } from '@/types';
import { User, Lock, MapPin, Briefcase } from 'lucide-react';

export default function AuthPage() {
  const router = useRouter();
  const [isLogin, setIsLogin] = useState(true);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [role, setRole] = useState<UserRole>('user');
  const [city, setCity] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleAuth = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      if (isLogin) {
        const { data, error } = await supabase.auth.signInWithPassword({
          email,
          password,
        });

        if (error) throw error;

        router.push('/categories');
      } else {
        const { data, error } = await supabase.auth.signUp({
          email,
          password,
        });

        if (error) throw error;

        if (data.user) {
          const { error: profileError } = await supabase.from('users').insert({
            id: data.user.id,
            email: email,
            role: role,
            city: city,
            location: city,
            created_at: new Date().toISOString(),
          });

          if (profileError) throw profileError;

          router.push('/categories');
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
          <h1 className="text-3xl font-bold text-white mb-2">
            {isLogin ? 'Iniciar Sesión' : 'Crear Cuenta'}
          </h1>
          <p className="text-white/70">
            {isLogin ? 'Bienvenido de nuevo' : 'Únete a Servicios del Hogar'}
          </p>
        </div>

        <form onSubmit={handleAuth} className="space-y-6">
          <div>
            <label className="block text-white mb-2 flex items-center gap-2">
              <User className="w-4 h-4" />
              Correo Electrónico
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              className="w-full px-4 py-3 rounded-xl glass text-white placeholder-white/50 focus:outline-none focus:ring-2 focus:ring-white/50"
              placeholder="tu@email.com"
            />
          </div>

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
            <>
              <div>
                <label className="block text-white mb-2 flex items-center gap-2">
                  <Briefcase className="w-4 h-4" />
                  Tipo de Cuenta
                </label>
                <select
                  value={role}
                  onChange={(e) => setRole(e.target.value as UserRole)}
                  className="w-full px-4 py-3 rounded-xl glass text-white focus:outline-none focus:ring-2 focus:ring-white/50"
                >
                  <option value="user" className="bg-gray-800">Usuario Normal</option>
                  <option value="seller" className="bg-gray-800">Vendedor/Profesional</option>
                </select>
              </div>

              <div>
                <label className="block text-white mb-2 flex items-center gap-2">
                  <MapPin className="w-4 h-4" />
                  Ciudad
                </label>
                <select
                  value={city}
                  onChange={(e) => setCity(e.target.value)}
                  required
                  className="w-full px-4 py-3 rounded-xl glass text-white focus:outline-none focus:ring-2 focus:ring-white/50"
                >
                  <option value="" className="bg-gray-800">Selecciona tu ciudad</option>
                  {citiesColombia.map((c) => (
                    <option key={c.id} value={c.name} className="bg-gray-800">
                      {c.name}, {c.department}
                    </option>
                  ))}
                </select>
              </div>
            </>
          )}

          {error && (
            <div className="glass-dark px-4 py-3 rounded-xl text-red-300 text-sm">
              {error}
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
