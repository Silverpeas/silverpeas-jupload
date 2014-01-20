//
// $Id$
//
// jupload - A file upload applet.
//
// Copyright 2012 The JUpload Team
//
// Created: 5 nov. 2012
// Creator: etienne_sf
// Last modified: $Date$
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

package wjhk.jupload2.upload;

import java.util.concurrent.BlockingQueue;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;
import org.junit.Before;
import org.junit.Test;

import wjhk.jupload2.exception.JUploadException;
import wjhk.jupload2.exception.JUploadInterrupted;

/**
 * @author etienne_sf
 */
public class DefaultFileUploadThreadTest extends AbstractJUploadTestHelper {

    private static String DEFAULT_THREAD_NAME = "DefaultFileUploadThread thread name";

    private static long DEFAULT_MAX_CHUNK_SIZE = 100;

    /** The object to tests */
    DefaultFileUploadThread defaultFileUploadThread = null;

    /** Mock object */
    BlockingQueue<UploadFilePacket> packetQueue = null;

    /** Mock object */
    FileUploadManagerThread fileUploadManagerThread = null;

    /**
     * 
     */
    public DefaultFileUploadThreadTest() {
        // TODO Auto-generated constructor stub
    }

    @SuppressWarnings("unchecked")
    @Before
    public void before() {
        // Creation of the Mock objects, which will be used in this test.
        packetQueue = mock(BlockingQueue.class);
        fileUploadManagerThread = mock(FileUploadManagerThread.class);

        // Creation of the object we'll test.
        defaultFileUploadThread = new DefaultFileUploadThreadTestHelper(
                DEFAULT_THREAD_NAME, packetQueue, uploadPolicy,
                fileUploadManagerThread);
        defaultFileUploadThread.maxChunkSize = DEFAULT_MAX_CHUNK_SIZE;
    }

    @Test
    public void testConstructor() {
        assertEquals("Check of thread name", DEFAULT_THREAD_NAME,
                defaultFileUploadThread.getName());
        assertEquals("Check of packetQueue", packetQueue,
                defaultFileUploadThread.packetQueue);
        assertEquals("Check of uploadPolicy", uploadPolicy,
                defaultFileUploadThread.uploadPolicy);
        assertEquals("Check of fileUploadManagerThread",
                fileUploadManagerThread,
                defaultFileUploadThread.fileUploadManagerThread);
    }

    @Test
    public void testDoChunkedUpload_2chunks() throws JUploadException,
            JUploadInterrupted {
        final long UPLOAD_LENGHT = 148;
        // Test preparation
        UploadFilePacket packet = new UploadFilePacket(uploadPolicy);
        UploadFileData mockerUploadFileData = mock(UploadFileData.class);
        when(mockerUploadFileData.getUploadLength()).thenReturn(UPLOAD_LENGHT);
        when(mockerUploadFileData.getRemainingLength())
                .thenReturn(UPLOAD_LENGHT).thenReturn(UPLOAD_LENGHT - 100)
                .thenReturn(UPLOAD_LENGHT - 100).thenReturn((long) 0);
        packet.add(mockerUploadFileData);

        // For verifications:
        DefaultFileUploadThread spyDefaultFileUploadThread = spy(defaultFileUploadThread);

        // Test execution
        spyDefaultFileUploadThread.doUpload(packet);

        // Checks (final methods can't be verified through the 'verify' method
        // of Mockito ... too bad, let's find workarounds).
        verify(spyDefaultFileUploadThread).doUpload(packet);
        verify(spyDefaultFileUploadThread).doChunkedUpload(packet);
        verify(mockerUploadFileData).uploadFile(
                spyDefaultFileUploadThread.getOutputStream(), 100);
        verify(mockerUploadFileData).uploadFile(
                spyDefaultFileUploadThread.getOutputStream(), 48);
    }

    @Test
    public void testDoChunkedUpload_2chunks_lastChunkFull()
            throws JUploadException, JUploadInterrupted {
        final long UPLOAD_LENGHT = 200;
        // Test preparation
        UploadFilePacket packet = new UploadFilePacket(uploadPolicy);
        UploadFileData mockerUploadFileData = mock(UploadFileData.class);
        when(mockerUploadFileData.getUploadLength()).thenReturn(UPLOAD_LENGHT);
        when(mockerUploadFileData.getRemainingLength())
                .thenReturn(UPLOAD_LENGHT).thenReturn(UPLOAD_LENGHT - 100)
                .thenReturn(UPLOAD_LENGHT - 100).thenReturn((long) 0);
        packet.add(mockerUploadFileData);

        // For verifications:
        DefaultFileUploadThread spyDefaultFileUploadThread = spy(defaultFileUploadThread);

        // Test execution
        spyDefaultFileUploadThread.doUpload(packet);

        // Checks (final methods can't be verified through the 'verify' method
        // of Mockito ... too bad, let's find workarounds).
        verify(spyDefaultFileUploadThread).doUpload(packet);
        verify(spyDefaultFileUploadThread).doChunkedUpload(packet);
        verify(mockerUploadFileData, times(2)).uploadFile(
                spyDefaultFileUploadThread.getOutputStream(), 100);
    }

    @Test
    public void testDoChunkedUpload_4chunks() throws JUploadException,
            JUploadInterrupted {
        final long UPLOAD_LENGHT = 349;
        // Test preparation
        UploadFilePacket packet = new UploadFilePacket(uploadPolicy);
        UploadFileData mockerUploadFileData = mock(UploadFileData.class);
        when(mockerUploadFileData.getUploadLength()).thenReturn(UPLOAD_LENGHT);
        when(mockerUploadFileData.getRemainingLength())
                .thenReturn(UPLOAD_LENGHT).thenReturn(UPLOAD_LENGHT - 100)
                .thenReturn(UPLOAD_LENGHT - 200)
                .thenReturn(UPLOAD_LENGHT - 300)
                .thenReturn(UPLOAD_LENGHT - 300).thenReturn((long) 0);
        packet.add(mockerUploadFileData);

        // For verifications:
        DefaultFileUploadThread spyDefaultFileUploadThread = spy(defaultFileUploadThread);

        // Test execution
        spyDefaultFileUploadThread.doUpload(packet);

        // Checks (final methods can't be verified through the 'verify' method
        // of Mockito ... too bad, let's find workarounds).
        verify(spyDefaultFileUploadThread).doUpload(packet);
        verify(spyDefaultFileUploadThread).doChunkedUpload(packet);
        verify(mockerUploadFileData, times(3)).uploadFile(
                spyDefaultFileUploadThread.getOutputStream(), 100);
        verify(mockerUploadFileData).uploadFile(
                spyDefaultFileUploadThread.getOutputStream(), 49);
    }
}
