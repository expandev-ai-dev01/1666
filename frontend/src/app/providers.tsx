import { QueryClientProvider } from '@tanstack/react-query';
import { ErrorBoundary } from '@/core/components/ErrorBoundary';
import { queryClient } from '@/core/lib/queryClient';
import { AppRouter } from './router';

export function Providers() {
  return (
    <ErrorBoundary fallback={<div>Something went wrong</div>}>
      <QueryClientProvider client={queryClient}>
        <AppRouter />
      </QueryClientProvider>
    </ErrorBoundary>
  );
}
