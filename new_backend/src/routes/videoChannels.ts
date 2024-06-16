import {Router} from 'express';
import videoChannelController from '../controllers/videoChannel';
import isAuthenticated from '../middlewares/authenticate';

const router = Router();

router.post('/',isAuthenticated, videoChannelController.createVideoChannel);
router.get('/',isAuthenticated,videoChannelController.getVideoChannel);
router.get('/:id',isAuthenticated,videoChannelController.getVideoChannelById);
router.put('/update/:id',isAuthenticated,videoChannelController.updateVideoChannel);
router.delete('/delete/:id',isAuthenticated,videoChannelController.deleteVideoChannel);

export default router;

