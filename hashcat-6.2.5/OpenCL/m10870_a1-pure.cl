/**
 * Author......: See docs/credits.txt
 * License.....: MIT
 */

//#define NEW_SIMD_CODE

#ifdef KERNEL_STATIC
#include "inc_vendor.h"
#include "inc_types.h"
#include "inc_platform.cl"
#include "inc_common.cl"
#include "inc_scalar.cl"
#include "inc_hash_sha384.cl"
#endif

KERNEL_FQ void m10870_mxx (KERN_ATTR_BASIC ())
{
  /**
   * modifier
   */

  const u64 lid = get_local_id (0);
  const u64 gid = get_global_id (0);

  if (gid >= gid_max) return;

  /**
   * base
   */

  sha384_ctx_t ctx0;

  sha384_init (&ctx0);

  sha384_update_global_utf16le_swap (&ctx0, pws[gid].i, pws[gid].pw_len);

  /**
   * loop
   */

  for (u32 il_pos = 0; il_pos < il_cnt; il_pos++)
  {
    sha384_ctx_t ctx = ctx0;

    sha384_update_global_utf16le_swap (&ctx, combs_buf[il_pos].i, combs_buf[il_pos].pw_len);

    sha384_final (&ctx);

    const u32 r0 = l32_from_64_S (ctx.h[3]);
    const u32 r1 = h32_from_64_S (ctx.h[3]);
    const u32 r2 = l32_from_64_S (ctx.h[2]);
    const u32 r3 = h32_from_64_S (ctx.h[2]);

    COMPARE_M_SCALAR (r0, r1, r2, r3);
  }
}

KERNEL_FQ void m10870_sxx (KERN_ATTR_BASIC ())
{
  /**
   * modifier
   */

  const u64 lid = get_local_id (0);
  const u64 gid = get_global_id (0);

  if (gid >= gid_max) return;

  /**
   * digest
   */

  const u32 search[4] =
  {
    digests_buf[DIGESTS_OFFSET].digest_buf[DGST_R0],
    digests_buf[DIGESTS_OFFSET].digest_buf[DGST_R1],
    digests_buf[DIGESTS_OFFSET].digest_buf[DGST_R2],
    digests_buf[DIGESTS_OFFSET].digest_buf[DGST_R3]
  };

  /**
   * base
   */

  sha384_ctx_t ctx0;

  sha384_init (&ctx0);

  sha384_update_global_utf16le_swap (&ctx0, pws[gid].i, pws[gid].pw_len);

  /**
   * loop
   */

  for (u32 il_pos = 0; il_pos < il_cnt; il_pos++)
  {
    sha384_ctx_t ctx = ctx0;

    sha384_update_global_utf16le_swap (&ctx, combs_buf[il_pos].i, combs_buf[il_pos].pw_len);

    sha384_final (&ctx);

    const u32 r0 = l32_from_64_S (ctx.h[3]);
    const u32 r1 = h32_from_64_S (ctx.h[3]);
    const u32 r2 = l32_from_64_S (ctx.h[2]);
    const u32 r3 = h32_from_64_S (ctx.h[2]);

    COMPARE_S_SCALAR (r0, r1, r2, r3);
  }
}